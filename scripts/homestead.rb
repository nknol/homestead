class Homestead
  def Homestead.configure(config, settings)
    # Configure The Box
    config.vm.box = "camdesigns/basebox"
    config.vm.hostname = settings["name"]

    # Configure A Private Network IP
    config.vm.network :private_network, ip: settings["ip"] ||= "192.168.10.10"

    # Configure A Few VirtualBox Settings
    config.vm.provider "virtualbox" do |vb|
      vb.name = settings["name"]
      vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
      vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
    end

    # Configure Port Forwarding To The Box
    # Configure Port Forwarding To The Box
    if settings.has_key?("ports")
      settings["ports"].each do |port|
        config.vm.network "forwarded_port", guest: port["map"], host: port["to"]
      end
    end

    # Configure The Public Key For SSH Access
    config.vm.provision "shell" do |s|
      s.inline = "git config --global http.sslverify false && echo $1 | grep -xq \"$1\" /home/vagrant/.ssh/authorized_keys || echo $1 | tee -a /home/vagrant/.ssh/authorized_keys && echo -e \"Host github.com\n\tStrictHostKeyChecking no\n\" >> ~/.ssh/config && echo -e \"Host elephanthub.net\n\tStrictHostKeyChecking no\n\" >> ~/.ssh/config"
      s.args = [File.read(File.expand_path(settings["authorize"]))]
    end

    # Copy The SSH Private Keys To The Box
    settings["keys"].each do |key|
      config.vm.provision "shell" do |s|
        s.privileged = false
        s.inline = "echo \"$1\" > /home/vagrant/.ssh/$2 && chmod 600 /home/vagrant/.ssh/$2"
        s.args = [File.read(File.expand_path(key)), key.split('/').last]
      end
    end

    # Copy The Bash Aliases
    config.vm.provision "shell" do |s|
      s.inline = "cp /vagrant/aliases /home/vagrant/.bash_aliases"
    end

    # Register All Of The Configured Shared Folders # https://github.com/laravel/homestead/pull/70
    if settings.has_key?("folders")
      settings["folders"].each do |folder|
        config.vm.synced_folder folder["map"], folder["to"], type: folder["type"] ||= nil, :nfs => true
      end
    end

    # Install All The Configured Nginx Sites
    if settings.has_key?("sites")
      settings["sites"].each do |site|
        config.vm.provision "shell" do |s|
            s.inline = "bash /vagrant/scripts/serve.sh $1 $2"
            s.args = [site["map"], site["to"]]
        end
      end
    end

    if settings.has_key?("repos")
      settings["repos"].each do |repo|
        config.vm.provision "shell" do |s|
            s.inline = "bash /vagrant/scripts/git.sh $1 $2"
            s.args = [repo["from"], repo["dir"]]
        end
      end
    end

    # Symlink the files
    if settings.has_key?("files")
      settings["files"].each do |file|
        config.vm.provision "shell" do |s|
            s.inline = "sudo ln -s $1 $2"
            s.args = [file["from"], file["to"]]
        end
      end
    end

    # Configure All Of The Server Environment Variables
    if settings.has_key?("variables")
      settings["variables"].each do |var|
        config.vm.provision "shell" do |s|
            s.inline = "echo \"\nenv[$1] = '$2'\" >> /etc/php5/fpm/php-fpm.conf && service php5-fpm restart"
            s.args = [var["key"], var["value"]]
        end
      end
    end

    # # Create PostgreSQL Databases # https://github.com/laravel/homestead/pull/51/files
    # settings["databases"]["postgresql"].each do |postgresql|
    #   if !(postgresql.nil?)
    #     config.vm.provision "shell" do |s|
    #       s.privileged = false
    #       s.inline = "export PGPASSWORD=secret;createdb -U homestead -h localhost \"$1\";"
    #       s.args = postgresql
    #     end
    #   end
    # end

    # # Create MySQL Databases
    # settings["databases"]["mysql"].each do |mysql|
    #   if !(mysql.nil?)
    #     config.vm.provision "shell" do |s|
    #       s.privileged = false
    #       s.inline = "export MYSQL_PWD=secret;mysql -u homestead -h localhost -e \"create database $1\";"
    #       s.args = mysql
    #     end
    #   end
    # end

    # Run Any Optional Commands # https://github.com/laravel/homestead/pull/76
    if settings.has_key?("commands")
      settings["commands"].each do |command|
        config.vm.provision "shell" do |s|
            s.inline = command
        end
      end
    end

    # Configure Git User
    if settings.has_key?("git")
      settings["git"].each do |g|
        config.vm.provision "shell" do |s|
            s.privileged = false
            s.inline = "git config --global user.name \"$1\" && git config --global user.email \"$2\""
            s.args = [g["name"], g["email"]]
        end
      end
    end

  # Updating the hosts file with all the sites that are defined in Homestead.yaml
  if Vagrant.has_plugin?("vagrant-hostsupdater") && site["hosts_file_additions"] == true
        hosts = []
        settings["sites"].each do |site|
          hosts.push(site["map"])
        end
        config.hostsupdater.aliases = hosts
    end
  end
end
