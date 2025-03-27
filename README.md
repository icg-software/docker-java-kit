## Oracle JDK, OpenJDK and java tools based on CentOS:7

This is docker image provides Oracle JDK and OpenJDK. 

**Using the image, you accept the [Oracle Binary Code License Agreement](http://www.oracle.com/technetwork/java/javase/terms/license/index.html) for Java SE!!!**

### Source Repository

@see on [GitHub](https://github.com/spalarus/docker-java-kit) ([Dockerfile](https://github.com/spalarus/docker-java-kit/blob/master/Dockerfile))

### Purpose

* JRE
* Jenkins slave
* base image for java services
* command-line development

### Tools

* vi
* subversion
* git
* mvn (3.8, 3.9)
* ant 1.9
* gradle 8.13
* nodejs 22
* npm 6.9

### Select java implementation 

**Run container with Oracle JDK**
```bash
docker run -it --rm \
    -e JDK_IMPLEMENTATION=ORACLEJDK \
    spalarus/java-kit java -version 

Set JDK Implementation to OracleJDK
java version "1.8.0_442"
Java(TM) SE Runtime Environment (build 1.8.0_442-b14)
Java HotSpot(TM) 64-Bit Server VM (build 25.201-b09, mixed mode)
```
 
**Run container with OpenJDK**
```bash
docker run -it --rm \
    -e JDK_IMPLEMENTATION=OPENJDK \
    spalarus/java-kit java -version 

Set JDK Implementation to OpenJDK
openjdk version "1.8.0_442"
OpenJDK Runtime Environment (build 1.8.0_442-b14)
OpenJDK 64-Bit Server VM (build 25.442-b14, mixed mode)
```
 
**Switch implementation inside**
```bash
docker run -it --rm  spalarus/java-kit

[root@0d66589dee11 ~]# /bin/switch_jdk_impl.sh oraclejdk
Set JDK Implementation to OracleJDK
[root@0d66589dee11 ~]# java -version
java version "1.8.0_442"
Java(TM) SE Runtime Environment (build 1.8.0_442-b14)
Java HotSpot(TM) 64-Bit Server VM (build 25.442-b14, mixed mode)

[root@0d66589dee11 ~]# /bin/switch_jdk_impl.sh openjdk
Set JDK Implementation to OpenJDK
[root@0d66589dee11 ~]# java -version
openjdk version "1.8.0_442"
OpenJDK Runtime Environment (build 1.8.0_442-b14)
OpenJDK 64-Bit Server VM (build 25.442-b14, mixed mode)
```
 
### Environment VARs

| VAR                  | Description                                   | Value                       |
|----------------------|-----------------------------------------------|-----------------------------|
| JDK_IMPLEMENTATION   | switch selecting JDK                          | ORACLEJDK / OPENJDK         |
| MVN_IMPLEMENTATION   | switch for MVN-Version                        | MVN38 / MVN39       |
| JENKINS_PWD          | create User jenkins (first start / uid 1000)  | password for jenkins usr    |
| SSH_KEYGEN           | generate new hostkey (first start)            | true / false                |

### Docker slave

This image can be used for [Jenkins Docker Plugin](https://wiki.jenkins.io/display/JENKINS/Docker+Plugin) as ssh-slave. You have to configure jenkins password by VAR JENKINS_PWD. Jenkins start sshd bei default (/usr/sbin/sshd -D) and expose port 22.
