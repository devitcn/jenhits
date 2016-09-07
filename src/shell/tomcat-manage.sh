#!/bin/sh
# LICENSE APACHE ASL
# AUTHOR: lxbzmy@gmail.com
# FOR TOMCAT6
#
HOST=http://172.22.61.111:80
USERNAME=admin
PASS=admin




#SCRIPT=$(readlink -f "$0")
#SCRIPTPATH=$(dirname "$SCRIPT")

p=`printf $USERNAME:$PASS | base64 -`
A="Authorization: Basic $p"
API="$HOST/manager"
case $1 in
list)
  curl -H "$A" "$HOST/manager/list"
;;
deploy1)
  curl -XPUT -H "$A" "$API/deploy?update=true&path=$3" --data-binary @$2
  #assert:OK - Deployed application at context path /demo
  ;;
deploy)
  curl -XPUT -H "$A" "$API/deploy?path=$3&war=file:$2&update=true"
  ##assert OK - Deployed application at context path /foo
undeploy)
  curl -XPUT -H "$A" "$API/undeploy?path=$2"
reload)
  curl -XPUT -H "$A" "$API/reload?path=$2"
;;  
*)
  echo '参数提示：
| 意图 | 参数例子 |  
列出已经部署的WAR    | list
上传一个WAR到TOMCAT | deploy1 ~/maven-demo/target/maven-dmeo.war /demo
部署已经在服务器上的WAR（路径是绝对路径）| deploy /app/tmp/demo.war /demo

  ' 
  ;; 
esac