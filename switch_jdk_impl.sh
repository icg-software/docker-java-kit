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
        alternatives --set javac /usr/java/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}/bin/javac
        alternatives --set java /usr/java/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR}/jre/bin/java
        rm /opt/jdk/latest
        ln -s /usr/java/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/jdk/latest
        ;;

    openjdk)
        echo "Set JDK Implementation to OpenJDK"
        alternatives --set javac /usr/lib/jvm/${RHEL_OPENJDK_PKG_NAME}-${RHEL_OPENJDK_VERSION}-${RHEL_OPENJDK_RELEASE}.x86_64/bin/javac
        alternatives --set java /usr/lib/jvm/${RHEL_OPENJDK_PKG_NAME}-${RHEL_OPENJDK_VERSION}-${RHEL_OPENJDK_RELEASE}.x86_64/jre/bin/java
        rm /opt/jdk/latest
        ln -s /usr/lib/jvm/${RHEL_OPENJDK_PKG_NAME}-${RHEL_OPENJDK_VERSION}-${RHEL_OPENJDK_RELEASE}.x86_64 /opt/jdk/latest
        ;;
esac
