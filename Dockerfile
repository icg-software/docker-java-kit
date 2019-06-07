FROM centos:7

MAINTAINER spalarus <s.palarus@googlemail.com>

# Set installation details

ARG JAVA_VERSION_MAJOR=8
ARG JAVA_VERSION_MINOR=201
ARG JAVA_VERSION_BUILD=09
ARG RHEL_OPENJDK_PKG_NAME=java-1.${JAVA_VERSION_MAJOR}.0-openjdk
ARG RHEL_OPENJDK_VERSION=1.${JAVA_VERSION_MAJOR}.0.${JAVA_VERSION_MINOR}.b${JAVA_VERSION_BUILD}
ARG RHEL_OPENJDK_RELEASE=2.el7_6
ARG MVN33_VERSION=3.3.9
ARG MVN35_VERSION=3.5.4
ARG MVN36_VERSION=3.6.1
ARG APACHE_MIRROR=mirrors.sonic.net
ARG GRADLE_VERSION=5.4.1
ARG LTS_NODEJS=10

# complete RHEL installation

RUN yum update -y && \
    yum install -y wget curl zip unzip vim sudo openssh-server openssh-clients org-x11-server-Xvfb && \
    yum install -y ${RHEL_OPENJDK_PKG_NAME}-${RHEL_OPENJDK_VERSION} ${RHEL_OPENJDK_PKG_NAME}-devel-${RHEL_OPENJDK_VERSION} && \
    mkdir /opt/jdk && \
    ln -s /usr/lib/jvm/${RHEL_OPENJDK_PKG_NAME}-${RHEL_OPENJDK_VERSION}-2.${RHEL_OPENJDK_RELEASE}.x86_64 /opt/jdk/latest && \
    yum install -y git ant subversion

# install oracle jdk  

RUN wget https://github.com/frekele/oracle-java/releases/download/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm && \
    md5sum  jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm > /root/jdk-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.rpm.md5 && \ 
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
    sed -ri "s/MVN35_VERSION=/MVN35_VERSION=${MVN35_VERSION}/g" /bin/switch_mvn_impl.sh && \
    sed -ri "s/MVN36_VERSION=/MVN36_VERSION=${MVN36_VERSION}/g" /bin/switch_mvn_impl.sh

RUN chmod u+x /bin/switch_jdk_impl.sh && chmod u+x /bin/switch_mvn_impl.sh && \
                chmod u+x /sbin/initjdk.sh &&  chmod u+x /entrypoint.sh && \
    echo 'Defaults    env_keep += "JENKINS_PWD SSH_KEYGEN JAVA_KIT_INIT_COMMAND"' >> /etc/sudoers.d/jdk && \
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
    rm -f apache-maven-${MVN35_VERSION}-bin.tar.gz && \
    wget http://${APACHE_MIRROR}/apache/maven/maven-3/${MVN36_VERSION}/binaries/apache-maven-${MVN36_VERSION}-bin.tar.gz && \
    tar -zxf apache-maven-${MVN36_VERSION}-bin.tar.gz && \
    tar -C /usr/local -xzf apache-maven-${MVN36_VERSION}-bin.tar.gz && \
    rm -f apache-maven-${MVN36_VERSION}-bin.tar.gz
    
# install gradle

RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip -d /usr/local gradle-${GRADLE_VERSION}-bin.zip && \
    ln -s /usr/local/gradle-${GRADLE_VERSION} /opt/gradle && \
    ln -s /opt/gradle/bin/gradle /usr/bin/gradle && \
    rm -f gradle-${GRADLE_VERSION}-bin.zip
    
# install nodejs / npm

RUN curl -sL https://rpm.nodesource.com/setup_${LTS_NODEJS}.x | sudo bash - && \
    yum install -y nodejs && \
    yum install -y gcc-c++ make

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
ENV JAVA_KIT_INIT_COMMAND=NONE

# Define working directory.

WORKDIR ${HOME}

# Define entrypoint

ENTRYPOINT ["/entrypoint.sh"]

# Define default command.

CMD ["bash"] 
