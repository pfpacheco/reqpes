# ------------------------------------------------------------------------------
#               NOTE: THIS DOCKERFILE IS GENERATED VIA "build_latest.sh" or "update_multiarch.sh"
#
#                       PLEASE DO NOT EDIT IT DIRECTLY.
# ------------------------------------------------------------------------------
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM ubuntu:14.04
MAINTAINER Paulo Francesco Pacheco <pfpacheco@gmail.com>

#Install Open JDK 6

ARG MAVEN_VERSION=3.2.5
ARG USER_HOME_DIR="/tmp"
ARG SHA=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN apt-get update \
    && apt-get -y install openjdk-6-jdk wget curl \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-6-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH

RUN wget -O /tmp/jboss-as-7.1.1.Final.tar.gz http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz --progress=dot:giga; \
    mkdir -p /opt/jboss; \
    cd /opt/jboss; \
    tar -xf /tmp/jboss-as-7.1.1.Final.tar.gz --strip-components=1; \
    rm -rf jboss-as-7.1.1.Final.tar.gz;

RUN mkdir -p /usr/share/maven /usr/share/maven/ref; \
    curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz; \
    echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
    tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1; \
    rm -f /tmp/apache-maven.tar.gz; \
    ln -s /usr/share/maven/bin/mvn /usr/bin/mvn;

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY settings-docker.xml /usr/share/maven/ref/

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]

RUN sed -i -r 's/jboss.bind.address.management:127.0.0.1/jboss.bind.address.management:0.0.0.0/' /opt/jboss/standalone/configuration/standalone.xml

EXPOSE 8080 9990

ENV JAVA_OPTS -Xms64m -Xmx512m

CMD ["/opt/jboss/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]

RUN mkdir -p /opt/reqpes

COPY ../../reqpes/ /opt/reqpes

WORKDIR /opt/reqpes

RUN mvn clean compile \
    && mvn deploy;

