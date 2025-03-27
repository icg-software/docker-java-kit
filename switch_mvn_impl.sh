#!/bin/bash

MVN38_VERSION=
MVN39_VERSION=

case "$1" in
    mvn33)
        echo "Set Maven 3.8"
        rm /opt/mvn
        rm /usr/bin/mvn
        rm /usr/bin/mvnDebug
        rm /usr/bin/mvnyjp
        rm /usr/local/apache-maven
        ln -s /usr/local/apache-maven-${MVN38_VERSION} /usr/local/apache-maven
        ln -s /usr/local/apache-maven-${MVN38_VERSION} /opt/mvn
        ln -s /usr/local/apache-maven-${MVN38_VERSION}/bin/mvn /usr/bin/mvn
        ln -s /usr/local/apache-maven-${MVN38_VERSION}/bin/mvnDebug /usr/bin/mvnDebug
        ln -s /usr/local/apache-maven-${MVN38_VERSION}/bin/mvnyjp /usr/bin/mvnyjp
        ;;

    mvn35)
        echo "Set Maven 3.9"
        rm /opt/mvn
        rm /usr/bin/mvn
        rm /usr/bin/mvnDebug
        rm /usr/bin/mvnyjp
        rm /usr/local/apache-maven
        ln -s /usr/local/apache-maven-${MVN39_VERSION} /usr/local/apache-maven
        ln -s /usr/local/apache-maven-${MVN39_VERSION} /opt/mvn
        ln -s /usr/local/apache-maven-${MVN39_VERSION}/bin/mvn /usr/bin/mvn
        ln -s /usr/local/apache-maven-${MVN39_VERSION}/bin/mvnDebug /usr/bin/mvnDebug
        ln -s /usr/local/apache-maven-${MVN39_VERSION}/bin/mvnyjp /usr/bin/mvnyjp
        ;;
esac
