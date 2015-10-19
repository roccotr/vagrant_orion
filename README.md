# Orion on Debian Jessie Docker host

Setup for a Debian Jessie Docker host machine.

Try using Vagrant or run

	./provision/bootstrap.sh [--user NON ROOT USERNAME] [--proxy HTTPPROXY IF ANY]

on a fresh installation.

```
vagrant@dockerhost:~$ docker version
Client:
 Version:      1.8.2
 API version:  1.20
 Go version:   go1.4.2
 Git commit:   0a8c2e3
 Built:        Wed Oct  7 17:28:47 UTC 2015
 OS/Arch:      linux/amd64
Server:
 Version:      1.8.2
 API version:  1.20
 Go version:   go1.4.2
 Git commit:   0a8c2e3
 Built:        Wed Oct  7 17:28:47 UTC 2015
 OS/Arch:      linux/amd64
vagrant@dockerhost:~$ docker-compose version
docker-compose version: 1.4.2
docker-py version: 1.3.1
CPython version: 2.7.9
OpenSSL version: OpenSSL 1.0.1e 11 Feb 2013
vagrant@dockerhost:~$ rocker --version
rocker version 0.2.2 - e02af48 (master) 2015-09-17_16:31_GMT
vagrant@dockerhost:~$ rocker-compose --version
rocker-compose version 0.1.1 - 556efea (master) 2015-09-17_17:01_GMT
```
