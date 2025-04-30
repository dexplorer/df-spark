#!/bin/bash

SPARK_VERSION=3.5.4
SCALA_VERSION=2.12
WAREHOUSE_DIR="/nas/datalake/user/spark/warehouse"
POSTGRES_HOST="172.18.0.2"
HIVE_METASTORE_POSTGRES_DB="hive_metastore"
HIVE_METASTORE_HOST="hive-metastore"
METASTORE_DB_USER_NAME="hive"
METASTORE_DB_USER_PASSWORD="hivepass123"
SCHEMA_NAME="dl_asset_mgmt"
POSTGRES_JDBC_VERSION="42.2.24"
SPARK_HOME="/opt/spark"
SPARK_WORKLOAD=$1

echo "SPARK_WORKLOAD: $SPARK_WORKLOAD"

if [ "$SPARK_WORKLOAD" == "master" ];
then
  start-master.sh -p 7077

elif [ "$SPARK_WORKLOAD" == "worker" ];
then
  WORKER_PORT=${2:-8081}
  echo "$WORKER_PORT"

  start-worker.sh spark://spark-master:7077 \
  --webui-port $WORKER_PORT \
  --cores 1 \
  --memory 3G
  
elif [ "$SPARK_WORKLOAD" == "history" ]
then
  start-history-server.sh
elif [ "$SPARK_WORKLOAD" == "connect" ]
then
  # start-connect-server.sh --driver-memory 512M --executor-memory 500M --executor-cores 1 --packages org.apache.spark:spark-connect_2.12:3.5.4
  # --packages org.apache.spark:spark-connect_2.12:$SPARK_VERSION,org.apache.spark:spark-hive_2.12:$SPARK_VERSION,org.postgresql:postgresql:$POSTGRES_JDBC_VERSION \
  # --packages org.apache.spark:spark-connect_$SCALA_VERSION:$SPARK_VERSION \
  # --conf spark.sql.catalog.spark_catalog=org.apache.spark.sql.execution.datasources.v2.InMemoryTableCatalog \
  # --conf spark.sql.catalog.hive_metastore=org.apache.spark.sql.hive.HiveExternalCatalog \

  # --conf spark.sql.defaultCatalog=spark_catalog \
  # --conf spark.sql.catalog.spark_catalog.type=hive \
  # --conf spark.sql.catalog.spark_catalog.warehouse=$WAREHOUSE_DIR \

  # --conf spark.sql.catalog.spark_catalog=org.apache.iceberg.spark.SparkSessionCatalog \
  # --master spark://172.18.0.4:7077 \

  # --conf spark.hadoop.hive.metastore.uris=thrift://$HIVE_METASTORE_HOST:9083 \
  # --conf hive.metastore.uris=thrift://$HIVE_METASTORE_HOST:9083 \
  # --conf javax.jdo.option.ConnectionURL="jdbc:postgresql://$POSTGRES_HOST:5432/$HIVE_METASTORE_POSTGRES_DB" \
  # --conf javax.jdo.option.ConnectionDriverName="org.postgresql.Driver" \
  # --conf javax.jdo.option.ConnectionUserName=$METASTORE_DB_USER_NAME \
  # --conf javax.jdo.option.ConnectionPassword=$METASTORE_DB_USER_PASSWORD \
  # --conf spark.hadoop.datanucleus.schema.autoCreateAll=true \
  # --conf spark.hadoop.hive.metastore.schema.verification=false
  # --conf spark.sql.warehouse.dir=$WAREHOUSE_DIR \
  # --conf spark.local.dir=$SPARK_HOME/local \
  # --conf spark.sql.hive.metastore.uris=thrift://$HIVE_METASTORE_HOST:9083


  start-connect-server.sh \
  --driver-memory 512M \
  --num-executors 1 \
  --executor-memory 500M \
  --executor-cores 1 \
  --conf spark.sql.catalogImplementation="hive"\
  --jars $SPARK_HOME/jars/spark-connect_$SCALA_VERSION-$SPARK_VERSION.jar, $SPARK_HOME/jars/postgresql-$POSTGRES_JDBC_VERSION.jar, $SPARK_HOME/jars/spark-hive_$SCALA_VERSION-$SPARK_VERSION.jar 
fi
