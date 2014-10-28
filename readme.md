#Forked from Laravel Homestead

- VBox 4.3.14
- vagrant 1.6.0+
- `vagrant box add camdesigns/basebox`
- `vagrant plugin install vagrant-vbguest`
- add mappings in `Homestead.yml`

##/etc/hosts
```
# Base App
127.0.0.1		homestead.dev
192.168.10.10   api.homestead.dev mock.homestead.dev docs.homestead.dev dist.homestead.dev genghis.homestead.dev beanstalkd.homestead.dev opcache.homestead.dev test.homestead.dev redis.homestead.dev
```

##mysql: `root:root`
  ![image](docs/mysql.png)

##Configuration Options sample file should be moved from `Homestead.sample.yaml` to `Homestead.yaml`

- VM options:
- 
 need to doc
