#!/bin/bash

rm /var/opt/firstboot

if [[ ! -z "${JENKINS_PWD}" ]]
then
    if [ "${JENKINS_PWD}" != "NONE" ]
    then
        echo "create jenkins user"
        useradd -m -d /home/jenkins -u 1000 -s /bin/sh jenkins && echo "jenkins:${JENKINS_PWD}" | chpasswd
        echo "export M2_HOME=/opt/mvn" >> /home/jenkins/.profile
        echo "export JAVA_HOME=/opt/latest/jdk" >> /home/jenkins/.profile
        echo "export JRE_HOME=/opt/latest/jdk/jre" >> /home/jenkins/.profile
    fi
fi

if [ "${SSH_KEYGEN}" = "true" ]
then
    echo "generate ssh host keys"
    rm /etc/ssh/ssh_host_*
    /usr/bin/ssh-keygen -A
fi
