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
3. Run the container `docker run -d --name mysql -v /var/lib/mysql:/<your>/<volume> bulgroz/mysql`
    * Add `-p xx.xx.xx.xx:3306:3306` to expose the server or simply link it to another container
    * name the container with `--name mysql` for easy linking
    * persist your data by mounting a volume with `-v /var/lib/mysql:/<your>/<volume>`
4. Get your (random) admin credentials by running `docker logs <id>` on the previously created container.

CAVEATS
=======

At this stage if your do not mount a volume on `/var/lib/mysql` (and persist the data **in the container**), the build script will fail to create the `admin` account, giving you no remote access to the container. 
This will be fixed in a future release, although you really should consider keeping the data outside of the container to simplify your backup strategy.

ABOUT ROOT
==========

The root account for mysql-server is created with `root` as password. This may seem insecure, however keep in mind that this account **can only be accessed from localhost**, ie, from the container itself.
