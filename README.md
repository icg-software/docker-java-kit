## Oracle JDK and OpenJDK based on CentOS:7

This is docker container based on CentOS 7 and contains Oracle JDK and OpenJDK. 

**Using the image, you accept the [Oracle Binary Code License Agreement](http://www.oracle.com/technetwork/java/javase/terms/license/index.html) for Java SE!!!**

### Select java implementation 

Run container with Oracle JDK
```bash
docker run -it --rm -e JDK_IMPLEMENTATION=ORACLEJDK spalarus/centos-jdk-hybrid java -version 
Set JDK Implementation to OracleJDK
java version "1.8.0_151"
Java(TM) SE Runtime Environment (build 1.8.0_151-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.151-b12, mixed mode)
```

Run container with OpenJDK
```bash
docker run -it --rm -e JDK_IMPLEMENTATION=OPENJDK spalarus/centos-jdk-hybrid java -version 
Set JDK Implementation to OpenJDK
openjdk version "1.8.0_151"
OpenJDK Runtime Environment (build 1.8.0_151-b12)
OpenJDK 64-Bit Server VM (build 25.151-b12, mixed mode)
```
Switch implementation inside
```bash
docker run -it --rm  spalarus/centos-jdk-hybrid

[root@0d66589dee11 ~]# /bin/switch_jdk_impl.sh oraclejdk
Set JDK Implementation to OracleJDK
[root@0d66589dee11 ~]# java -version
java version "1.8.0_151"
Java(TM) SE Runtime Environment (build 1.8.0_151-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.151-b12, mixed mode)

[root@0d66589dee11 ~]# /bin/switch_jdk_impl.sh openjdk
Set JDK Implementation to OpenJDK
[root@0d66589dee11 ~]# java -version
openjdk version "1.8.0_151"
OpenJDK Runtime Environment (build 1.8.0_151-b12)
OpenJDK 64-Bit Server VM (build 25.151-b12, mixed mode)
```
