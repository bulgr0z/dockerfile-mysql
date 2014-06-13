ABOUT
=====

+ This repository provides an easy-to-deploy, dockerised, mysql-server.
+ The container is running mysql-server-5.5 on Ubuntu 14.04 LTS.

CONFIG
======
+ Replace or modify the provided `conf/my.cnf` to suit your preferences.

USAGE
=====

1. Clone the repo and cd into it
2. Build the image with `docker build -t bulgroz/mysql .`
3. Run the container `docker run -d -p 127.0.0.1:3306:3306 bulgroz/mysql`
    * change the ports/interface to your liking
    * name the container with `--name mysql`
4. Get your (random) admin credentials by running `docker logs <id>` on the previously created container.

ABOUT ROOT
==========

The root account for mysql-server is created with `root` as password. This may seem insecure, however keep in mind that this account **can only be accessed from localhost**, ie, from the container itself.
