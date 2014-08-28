#Forked from Laravel Homestead

- VBox 4.3.14
- vagrant 1.6.0+
- `vagrant box add camdesigns/basebox`
- `vagrant plugin install vagrant-vbguest`
- add mappings in `homestead.yml`
- `ssh-keygen -t rsa -C "u@email.com"`

##/etc/hosts
`# Base App
127.0.0.1		base.app
192.168.10.10   api.base.app mock.base.app docs.base.app dist.base.app genghis.base.app beanstalkd.base.app opcache.base.app test.base.app redis.base.app
`

##mysql: `root:root`
  ![image](docs/mysql.png)

##TODO:

- add shortcuts for APIB
- beanstalkd app not working
-_arguments:450: _vim_files: function definition file not found
