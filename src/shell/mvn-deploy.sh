#!/bin/bash
#将本地库中的包发布到远端nexus库

url=$1
pomfile="${url%.*}.pom"
#path=`dirname $url`
#filename=`basename $url`
#noext=${name%.*}
#sources="${url%.*}-sources.jar"



#MVN有个BUG如果file里面有版本号还和pom的一样就不能上传了！！！
ln -sf $url foo
mvn deploy:deploy-file -DrepositoryId=nexus-snapshots \
-Durl=http://localhost:8081/repository/maven-releases/ \
-DpomFile=$pomfile -Dfile=foo
unlink foo

#文档：https://maven.apache.org/plugins/maven-deploy-plugin/deploy-file-mojo.html
#mvn deploy:deploy-file 
#-DrepositoryId=nexus-snapshots \ 
#-Durl=http://localhost:8081/repository/maven-releases/ \ 
#-DpomFile=junit-4.12.pom \
#-Dsources=junit-4.12-sources.jar \
#-DgroupId=com.foo \
#-DartifactId=bar-com1 \
#-Dpackaging=jar \
#-Dversion=1.0 \
#-Dfile=foo.jar \
#
#curl -v -X POST -H $CRUMB -H"Content-Type: application/xml" --data-binary @config.xml -u "${USERNAME}:${TOKEN}" ${JENKINS_URL}"/job/Demo/createItem?name=b"

#wget --auth-no-challenge --user=joe.shmoe --password=secret --header="Content-Type: application/xml"  \
#         --post-file=config.xml --no-check-certificate           \
#         https://jenkins.company.com/job/myProject/config.xml