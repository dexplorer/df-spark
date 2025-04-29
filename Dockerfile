FROM spark:3.5.4-scala2.12-java11-python3-ubuntu

USER root

WORKDIR /opt/spark/work

ARG APP_INFRA_USER_NAME=ec2-user
ARG APP_INFRA_USER_GROUP_NAME=ec2-user
ARG APP_INFRA_USER_ID=1000
ARG APP_INFRA_USER_GROUP_ID=1000
ARG WORKDIR=/opt/spark/work-dir
# ENV DELTA_PACKAGE_VERSION=delta-spark_2.12:${DELTA_SPARK_VERSION}
ENV PATH="/opt/spark/sbin:/opt/spark/bin:${PATH}"
ENV SPARK_HOME="/opt/spark"
ENV PYSPARK_PYTHON python3

RUN apt-get update -y \
    && apt-get install -y vim curl make

# RUN groupadd --system ${APP_INFRA_USER_GROUP} && useradd --system --create-home --gid ${APP_INFRA_USER_GROUP} ${APP_INFRA_USER_NAME}

#Add group first to avoid errors related to the user already existing
RUN groupadd --system -g ${APP_INFRA_USER_GROUP_ID} ${APP_INFRA_USER_GROUP_NAME} && useradd --system -u ${APP_INFRA_USER_ID} -g ${APP_INFRA_USER_GROUP_NAME} ${APP_INFRA_USER_NAME}

# Add hadoop-aws for spark-aws integration
# COPY --chown=${APP_INFRA_USER_NAME} ./spark_home/jars/hadoop-aws-3.3.4.jar /opt/spark/jars/hadoop-aws-3.3.4.jar
# COPY --chown=${APP_INFRA_USER_NAME} ./spark_home/jars/aws-java-sdk-bundle-1.12.782.jar /opt/spark/jars/aws-java-sdk-bundle-1.12.782.jar 
# for delta
# COPY --chown=${APP_INFRA_USER_NAME} ./spark_home/jars/delta-storage-3.1.0.jar /opt/spark/jars/delta-storage-3.1.0.jar
# COPY --chown=${APP_INFRA_USER_NAME} ./spark_home/jars/delta-spark_2.12-3.1.0.jar /opt/spark/jars/delta-spark_2.12-3.1.0.jar
# for postgres as hive metastore
COPY --chown=${APP_INFRA_USER_NAME} ./spark_home/jars/postgresql-42.2.24.jar /opt/spark/jars/postgresql-42.2.24.jar
COPY --chown=${APP_INFRA_USER_NAME} ./spark_home/conf/hive-site.xml /opt/spark/conf/hive-site.xml
COPY --chown=${APP_INFRA_USER_NAME} ./spark_home/conf/hive-site.xml /opt/hive/conf/hive-site.xml
# for spark-connect to postgres integration
COPY --chown=${APP_INFRA_USER_NAME} ./spark_home/jars/spark-connect_2.12-3.5.4.jar /opt/spark/jars/spark-connect_2.12-3.5.4.jar
COPY --chown=${APP_INFRA_USER_NAME} ./spark_home/jars/spark-hive_2.12-3.5.4.jar /opt/spark/jars/spark-hive_2.12-3.5.4.jar

# Copy the default configurations into $SPARK_HOME/conf
# COPY ./spark_home/conf/spark-defaults.conf "$SPARK_HOME/conf"

# Create the work directory and set ownership
RUN chown -R ${APP_INFRA_USER_NAME}:${APP_INFRA_USER_GROUP_NAME} /opt/spark/work \
    && mkdir -p /opt/spark/local \
    && chown -R ${APP_INFRA_USER_NAME}:${APP_INFRA_USER_GROUP_NAME} /opt/spark/local \
    && mkdir -p /opt/spark/logs \
    && chown -R ${APP_INFRA_USER_NAME}:${APP_INFRA_USER_GROUP_NAME} /opt/spark/logs \
    && mkdir -p /opt/spark/spark-events \
    && chown -R ${APP_INFRA_USER_NAME}:${APP_INFRA_USER_GROUP_NAME} /opt/spark/spark-events

#ENTRYPOINT ["spark-submit --master local", "basic_spark.py"]
COPY ./entrypoint.sh .
RUN chmod +x entrypoint.sh
# RUN chown=${APP_INFRA_USER_NAME} ${SPARK_HOME}
# USER ${APP_INFRA_USER_NAME}
ENTRYPOINT ["./entrypoint.sh", "master"]

