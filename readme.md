#Forked from Laravel Homestead

- `vagrant box add camdesigns/basebox`
- add mappings in `homestead.yml`
- `ssh-keygen -t rsa -C "u@email.com"`

##/etc/hosts
`# Base App
127.0.0.1		base.app
192.168.10.10   api.base.app mock.base.app docs.base.app dist.base.app genghis.base.app beanstalkd.base.app opcache.base.app test.base.app redis.base.app
`

##TODO:

- Add redis-commander to upstream box
- add shortcuts for APIB
- add Vim to upstream
- add mongo upstream
- benastalkd app not working
- test app not working
- opcache app not working
