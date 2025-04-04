#!/bin/bash

JAVA_VERSION_MAJOR=
JAVA_VERSION_MINOR=
ORA_JAVA_URL_HASH=
RHEL_OPENJDK_PKG_NAME=
RHEL_OPENJDK_VERSION=
RHEL_OPENJDK_RELEASE=

case "$1" in
    oraclejdk)
        echo "Set JDK Implementation to OracleJDK"
        alternatives --install /usr/bin/javac javac /usr/java/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}-amd64/bin/javac 2
        alternatives --install /usr/bin/java java /usr/java/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}-amd64/jre/bin/java 2
        alternatives --set javac /usr/java/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}-amd64/bin/javac
        alternatives --set java /usr/java/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}-amd64/jre/bin/java
        rm /opt/jdk/latest
        ln -s /usr/java/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}-amd64 /opt/jdk/latest
        ;;

    openjdk)
        echo "Set JDK Implementation to OpenJDK"
        alternatives --install /usr/bin/javac javac /usr/lib/jvm/${RHEL_OPENJDK_PKG_NAME}-${RHEL_OPENJDK_VERSION}-${RHEL_OPENJDK_RELEASE}.x86_64/bin/javac 2
        alternatives --install /usr/bin/java java /usr/lib/jvm/${RHEL_OPENJDK_PKG_NAME}-${RHEL_OPENJDK_VERSION}-${RHEL_OPENJDK_RELEASE}.x86_64/jre/bin/java 2
        alternatives --set javac /usr/lib/jvm/${RHEL_OPENJDK_PKG_NAME}-${RHEL_OPENJDK_VERSION}-${RHEL_OPENJDK_RELEASE}.x86_64/bin/javac
        alternatives --set java /usr/lib/jvm/${RHEL_OPENJDK_PKG_NAME}-${RHEL_OPENJDK_VERSION}-${RHEL_OPENJDK_RELEASE}.x86_64/jre/bin/java
        rm /opt/jdk/latest
        ln -s /usr/lib/jvm/${RHEL_OPENJDK_PKG_NAME}-${RHEL_OPENJDK_VERSION}-${RHEL_OPENJDK_RELEASE}.x86_64 /opt/jdk/latest
        ;;
esac
