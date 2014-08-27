class Homestead
  def Homestead.configure(config, settings)
    # Configure The Box
    config.vm.box = "camdesigns/basebox"
    config.vm.hostname = "basebox"

    # Configure A Private Network IP
    config.vm.network :private_network, ip: settings["ip"] ||= "192.168.10.10"

    # Configure A Few VirtualBox Settings
    config.vm.provider "virtualbox" do |vb|
      vb.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
      vb.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "1"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    end

    # Configure Port Forwarding To The Box
    config.vm.network "forwarded_port", guest: 80, host: 80
    config.vm.network "forwarded_port", guest: 3306, host: 3306
    config.vm.network "forwarded_port", guest: 5432, host: 5432

    # Configure The Public Key For SSH Access
    config.vm.provision "shell" do |s|
      s.inline = "echo $1 | tee -a /home/vagrant/.ssh/authorized_keys"
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

    # Setup Vim
    config.vm.provision "shell" do |s|
      s.inline = "cp -ir /vagrant/scripts/dot/.vim /home/vagrant/ && cp -ir /vagrant/scripts/dot/.vimrc /home/vagrant/ && cp -ir /vagrant/scripts/dot/.viminfo /home/vagrant/ && cp -ir /vagrant/scripts/dot/.multitailrc /home/vagrant/"
    end

   # Install Redis-Commander
    config.vm.provision "shell" do |s|
      s.inline = "sudo npm install -g redis-commander"
    end

    # Register All Of The Configured Shared Folders
    settings["folders"].each do |folder|
      config.vm.synced_folder folder["map"], folder["to"], type: folder["type"] ||= nil
    end

    # Install All The Configured Nginx Sites
    settings["sites"].each do |site|
      config.vm.provision "shell" do |s|
          s.inline = "bash /vagrant/scripts/nginx/serve.sh $1 $2"
          s.args = [site["map"], site["to"]]
      end
    end

    # Install Ghenghis App
    settings["genghis"].each do |site|
      config.vm.provision "shell" do |s|
          s.inline = "bash /vagrant/scripts/nginx/genghis.sh $1 $2"
          s.args = [site["map"], site["to"]]
      end
    end

    # Install Beanstalkd App
    settings["beanstalkd"].each do |site|
      config.vm.provision "shell" do |s|
          s.inline = "bash /vagrant/scripts/nginx/beanstalkd.sh $1 $2"
          s.args = [site["map"], site["to"]]
      end
    end

    # Install Opcache App
    settings["opcache"].each do |site|
      config.vm.provision "shell" do |s|
          s.inline = "bash /vagrant/scripts/nginx/opcache.sh $1 $2"
          s.args = [site["map"], site["to"]]
      end
    end

    # Install Test App
    settings["test"].each do |site|
      config.vm.provision "shell" do |s|
          s.inline = "bash /vagrant/scripts/nginx/test.sh $1 $2"
          s.args = [site["map"], site["to"]]
      end
    end

    # Install AngularDist App
    settings["angulardist"].each do |site|
      config.vm.provision "shell" do |s|
          s.inline = "bash /vagrant/scripts/nginx/angulardist.sh $1 $2"
          s.args = [site["map"], site["to"]]
      end
    end

     # Install Aglio App
    settings["aglio"].each do |site|
      config.vm.provision "shell" do |s|
          s.inline = "bash /vagrant/scripts/nginx/aglio.sh $1"
          s.args = [site["url"]]
      end
    end

    # Install Api-mock App
    settings["apimock"].each do |site|
      config.vm.provision "shell" do |s|
          s.inline = "bash /vagrant/scripts/nginx/apimock.sh $1"
          s.args = [site["url"]]
      end
    end

    # Install Redis-Commander App
    settings["rediscommander"].each do |site|
      config.vm.provision "shell" do |s|
          s.inline = "bash /vagrant/scripts/nginx/redis-commander.sh $1"
          s.args = [site["url"]]
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
  end
end
