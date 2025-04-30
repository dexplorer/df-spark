# df-spark

This repository contains configuration to spin up a spark standalone cluster using docker containers. The cluster will have the following containers.

* Postgres DB for Hive Metastore
* Hive Metastore
* Spark Master Node
* Spark Worker Node
* Spark History Server
* Spark Connect Server
* Firefox Browser

Note: Spark nodes are based on a standard spark docker image with custom configurations. There are several JARs needed. These are referenced in Dockerfile. Download these JARs (or wget) and place them under ./spark_home/jars before building the df-spark docker image.

### Spin up Spark Cluster using Docker Containers
```sh
APP_INFRA_USER_NAME="ec2-user" APP_INFRA_USER_GROUP_NAME="ec2-user" docker-compose up --build
```

