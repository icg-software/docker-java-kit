#!/bin/bash

if [ "${JDK_IMPLEMENTATION}" = "OPENJDK" ]
then
    sudo /bin/switch_jdk_impl.sh openjdk
fi

if [ "${JDK_IMPLEMENTATION}" = "ORACLEJDK" ]
then
    sudo /bin/switch_jdk_impl.sh oraclejdk
fi

if [ "${MVN_IMPLEMENTATION}" = "MVN38" ]
then
    sudo /bin/switch_mvn_impl.sh mvn38
fi

if [ "${MVN_IMPLEMENTATION}" = "MVN39" ]
then
    sudo /bin/switch_mvn_impl.sh mvn39
fi

if [ "${XVFB}" = "true" ]
then
    export DISPLAY="unix:99.0"
    Xvfb :99 -screen 0 1x1x16 > /dev/null 2>&1 &
fi

if [ -f /var/opt/firstboot ]
then
    sudo /sbin/initjdk.sh
fi

export JENKINS_PWD=''

exec "$@"
