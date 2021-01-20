FROM ubuntu:14.04
MAINTAINER Paulo Francesco Pacheco <pfpacheco@gmail.com>
#Install Open JDK 7

RUN apt-get update \
    && apt-get -y install openjdk-7-jdk wget curl \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_OPTS -Xms64m -Xmx512m -Duser.timezone=America/Sao_Paulo
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV JBOSS_HOME /opt/jboss
ENV PATH $JAVA_HOME/bin:$PATH

RUN wget -O /tmp/wildfly-8.0.0.Final.tar.gz http://download.jboss.org/wildfly/8.0.0.Final/wildfly-8.0.0.Final.tar.gz --progress=dot:giga; \
    mkdir -p $JBOSS_HOME; \
    cd $JBOSS_HOME; \
    tar -xf /tmp/wildfly-8.0.0.Final.tar.gz --strip-components=1; \
    rm -rf /tmp/wildfly-8.0.0.Final.tar.gz;

EXPOSE 8080 9990

CMD ["/opt/jboss/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]

COPY /ojdbc7.jar /tmp/

COPY /target/reqpes-1.0.war $JBOSS_HOME/standalone/deployments/
