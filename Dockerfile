FROM centos:7

MAINTAINER spalarus <s.palarus@googlemail.com>

# Set installation details

ARG JAVA_VERSION_MAJOR=8
ARG JAVA_VERSION_MINOR=151
ARG JAVA_VERSION_BUILD=12
ARG ORA_JAVA_URL_HASH=e758a0de34e24606bca991d704f6dcbf
ARG RHEL_OPENJDK_PKG_NAME=java-1.${JAVA_VERSION_MAJOR}.0-openjdk
ARG RHEL_OPENJDK_VERSION=1.${JAVA_VERSION_MAJOR}.0.${JAVA_VERSION_MINOR}
ARG RHEL_OPENJDK_RELEASE=1.b${JAVA_VERSION_BUILD}.el7_4
ARG MVN33_VERSION=3.3.9
ARG MVN35_VERSION=3.5.2
ARG APACHE_MIRROR=mirrors.sonic.net
ARG GRADLE_VERSION=4.3.1

# complete RHEL installation

RUN yum update -y && \
    yum install -y wget zip unzip vim sudo && \
    yum install -y git ant subversion && \
    yum install -y openssh-server openssh-clients && \
    yum install -y xorg-x11-server-Xvfb  && \
    yum install -y ${RHEL_OPENJDK_PKG_NAME}-${RHEL_OPENJDK_VERSION} ${RHEL_OPENJDK_PKG_NAME}-devel-${RHEL_OPENJDK_VERSION} && \
    mkdir /opt/jdk && \
    ln -s /usr/lib/jvm/${RHEL_OPENJDK_PKG_NAME}-${RHEL_OPENJDK_VERSION}-${RHEL_OPENJDK_RELEASE}.x86_64 /opt/jdk/latest

# install oracle jdk  

RUN wget --no-cookies --no-check-certificate \
    --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk8-downloads-2133151.html; oraclelicense=accept-securebackup-cookie" \
    "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${ORA_JAVA_URL_HASH}/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm" && \
    yum localinstall -y jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm && \
    rm -f jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm

# clean rpm/yum and prepare for first start

RUN yum clean all && \
    rm -rf /var/cache/yum && \
    touch /var/opt/firstboot && \
    /usr/bin/ssh-keygen -A

# my scripts

ADD ./switch_jdk_impl.sh /bin/switch_jdk_impl.sh
ADD ./switch_mvn_impl.sh /bin/switch_mvn_impl.sh
ADD ./initjdk.sh /sbin/initjdk.sh
ADD ./entrypoint.sh /entrypoint.sh

RUN sed -ri "s/JAVA_VERSION_MAJOR=/JAVA_VERSION_MAJOR=${JAVA_VERSION_MAJOR}/g" /bin/switch_jdk_impl.sh && \
    sed -ri "s/JAVA_VERSION_MINOR=/JAVA_VERSION_MINOR=${JAVA_VERSION_MINOR}/g" /bin/switch_jdk_impl.sh && \
    sed -ri "s/ORA_JAVA_URL_HASH=/ORA_JAVA_URL_HASH=${ORA_JAVA_URL_HASH}/g" /bin/switch_jdk_impl.sh && \
    sed -ri "s/RHEL_OPENJDK_PKG_NAME=/RHEL_OPENJDK_PKG_NAME=${RHEL_OPENJDK_PKG_NAME}/g" /bin/switch_jdk_impl.sh && \
    sed -ri "s/RHEL_OPENJDK_VERSION=/RHEL_OPENJDK_VERSION=${RHEL_OPENJDK_VERSION}/g" /bin/switch_jdk_impl.sh && \
    sed -ri "s/RHEL_OPENJDK_RELEASE=/RHEL_OPENJDK_RELEASE=${RHEL_OPENJDK_RELEASE}/g" /bin/switch_jdk_impl.sh && \
    sed -ri "s/MVN33_VERSION=/MVN33_VERSION=${MVN33_VERSION}/g" /bin/switch_mvn_impl.sh && \
    sed -ri "s/MVN35_VERSION=/MVN35_VERSION=${MVN35_VERSION}/g" /bin/switch_mvn_impl.sh

RUN chmod u+x /bin/switch_jdk_impl.sh && chmod u+x /bin/switch_mvn_impl.sh && \
                chmod u+x /sbin/initjdk.sh &&  chmod u+x /entrypoint.sh && \
    echo 'Defaults    env_keep += "JENKINS_PWD SSH_KEYGEN"' >> /etc/sudoers.d/jdk && \
    echo "ALL ALL=(ALL) NOPASSWD:  /bin/switch_jdk_impl.sh" >> /etc/sudoers.d/jdk && \
    echo "ALL ALL=(ALL) NOPASSWD:  /bin/switch_mvn_impl.sh" >> /etc/sudoers.d/jdk && \
    echo "ALL ALL=(ALL) NOPASSWD:  /sbin/initjdk.sh" >> /etc/sudoers.d/jdk
    
# install maven
    
RUN wget http://${APACHE_MIRROR}/apache/maven/maven-3/${MVN33_VERSION}/binaries/apache-maven-${MVN33_VERSION}-bin.tar.gz && \
    tar -zxf apache-maven-${MVN33_VERSION}-bin.tar.gz && \
    tar -C /usr/local -xzf apache-maven-${MVN33_VERSION}-bin.tar.gz && \
    rm -f apache-maven-${MVN33_VERSION}-bin.tar.gz && \
    wget http://${APACHE_MIRROR}/apache/maven/maven-3/${MVN35_VERSION}/binaries/apache-maven-${MVN35_VERSION}-bin.tar.gz && \
    tar -zxf apache-maven-${MVN35_VERSION}-bin.tar.gz && \
    tar -C /usr/local -xzf apache-maven-${MVN35_VERSION}-bin.tar.gz && \
    rm -f apache-maven-${MVN35_VERSION}-bin.tar.gz
    
# install gradle

RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip -d /usr/local gradle-${GRADLE_VERSION}-bin.zip && \
    ln -s /usr/local/gradle-${GRADLE_VERSION} /opt/gradle && \
    ln -s /opt/gradle/bin/gradle /usr/bin/gradle && \
    rm gradle-${GRADLE_VERSION}-bin.zip

# switch to default settings

RUN /bin/switch_jdk_impl.sh openjdk
RUN /bin/switch_mvn_impl.sh mvn35

# Set environment variables.

ENV HOME=/root
ENV JAVA_HOME=/opt/jdk/latest
ENV JRE_HOME=/opt/jdk/latest/jre 
ENV JAVA_OPTS=
ENV M2_HOME=/opt/mvn
ENV JDK_IMPLEMENTATION=KEEP
ENV MVN_IMPLEMENTATION=KEEP
ENV JENKINS_PWD=NONE
ENV SSH_KEYGEN=false
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV XVFB=false

# Define working directory.

WORKDIR ${HOME}

# Define entrypoint

ENTRYPOINT ["/entrypoint.sh"]

# Define default command.

CMD ["bash"] 
