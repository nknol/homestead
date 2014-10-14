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

```
ip : STRING
memory : INTEGER
port80, port3306, port5432 : INTEGERS
```

- Authorize key for ssh into the VM:

```
authorize: STRING
```

- Keys you want on the guest machine:

```
keys : ARRAY
	- STRING
	- ...
```

- Local to Guest shared folders:

```
folders:
    - map: STRING <PATH/ON/LOCALMACHINE>
      to: STRING <PATH/ON/GUESTMACHINE>
      
    - ...
```

- PHP &or Laravel specific Nginx sites:

```
sites : ARRAY
	- map: STRING <DOMAIN>
	  to: STRING <PATH/ON/GUEST>
	- ...
```

- PHP ENV variables

```
variables:
    - key: STRING <APP_ENV>
      value: STRING <local>
    
    - ...
```

- Files to be symlinked ( I use these for custoim nginx configuration ):

```
files:
    - from: STRING <FILE/TO/BE/LINKED/VIA/SHARE>
      to: STRING <FILE/TO/BE/LINKED/ON/GUEST>
    - ...
```

- Commands to be run at the end of provisioning

```
commands: ARRAY
    - STRING # sudo npm install -g sails
    - ...
```

- Repos to be cloned in given directory

```
repos:
    - from: STRING # git@github.com:laravel/homestead.git
      dir: STRING # /vagrant
    - ...
 ```

- Git user
```
git:
   - name: User
   - email: user@email.com
```

##TODO:
- add shortcuts for APIB
- beanstalkd app not working
