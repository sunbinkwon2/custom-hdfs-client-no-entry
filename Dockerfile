FROM centos:7

# install openJDK 1.8
RUN yum -y install java-1.8.0-openjdk.x86_64
RUN yum -y install wget
RUN yum -y install which

# Setup env
USER root
ENV JAVA_HOME /usr/lib/jvm/jre-1.8.0
ENV HADOOP_USER hdfs
ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /opt/cluster-conf



# download hadoop
RUN wget -q -O - http://apache.mirrors.pair.com/hadoop/common/hadoop-3.2.3/hadoop-3.2.3.tar.gz | tar -xzf - -C /usr/local \
&& ln -s /usr/local/hadoop-3.2.3 /usr/local/hadoop \
&& groupadd -r hadoop \
&& groupadd -r $HADOOP_USER && useradd -r -g $HADOOP_USER -G hadoop $HADOOP_USER

RUN mkdir -p $HADOOP_CONF_DIR

COPY ./core-site.xml /opt/cluster-conf
COPY ./hdfs-site.xml /opt/cluster-conf

# Setup permissions and ownership (httpfs tomcat conf for 600 permissions)
RUN chown -R $HADOOP_USER:hadoop /usr/local/hadoop-3.2.3 && chmod -R 775 $HADOOP_CONF_DIR

# set up hadoop user and bin path
ENV HADOOP_USER_NAME $HADOOP_USER
ENV PATH="${HADOOP_PREFIX}/bin:${PATH}"