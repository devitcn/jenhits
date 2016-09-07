#!/bin/sh
. /home/weblogic/Oracle/Middleware/wlserver_10.3/server/bin/setWLSEnv.sh
cp /home/weblogic/jenkinsJob/source/$1'.war'  /home/weblogic/Oracle/Middleware/user_projects/domains/domain1/servers/AdminServer/upload/
java \
-Xms128M -Xmx256M \
weblogic.Deployer \
-debug -remote -verbose \
-name $1 \
-source /home/weblogic/Oracle/Middleware/user_projects/domains/domain1/servers/AdminServer/upload/$1'.war' \
-targets AdminServer \
-adminurl t3://localhost:7001 \
-user weblogic -password 'weblogic1' -redeploy

# java weblogic.WLST
# connect('user','pass')
#https://docs.oracle.com/middleware/12213/wls/WLSTC/quick_ref.htm#WLSTC113