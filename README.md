# df-spark

This repository contains configuration to spin up a spark standalone cluster using docker containers. The cluster will have the following containers.

* Postgres DB for Hive Metastore
* Hive Metastore
* Spark Master Node
* Spark Worker Node
* Spark History Server
* Spark Connect Server
* Firefox Browser

### Spin up Spark Cluster using Docker Containers
```
APP_INFRA_USER_NAME="ec2-user" APP_INFRA_USER_GROUP_NAME="ec2-user" docker-compose up --build
```

