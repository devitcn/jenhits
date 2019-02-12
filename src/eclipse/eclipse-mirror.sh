#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
echo $SCRIPTPATH;
ECLIPSE=~/jee-photon/Eclipse.app/Contents/MacOS/eclipse


case $1 in
d)
$ECLIPSE -nosplash -headless -verbose \
 -application org.eclipse.equinox.p2.metadata.repository.mirrorApplication \
 -source http://download.oracle.com/otn_software/oepe/12.2.1.8/oxygen/repository/ \
 -destination $SCRIPTPATH/server-tools 

$ECLIPSE -nosplash -headless -verbose \
 -application org.eclipse.equinox.p2.artifact.repository.mirrorApplication \
 -source http://download.oracle.com/otn_software/oepe/12.2.1.8/oxygen/repository/ \
 -destination $SCRIPTPATH/server-tools  \
 -baseline http://download.eclipse.org/releases/2018-12/
 ;;  
*)
$ECLIPSE -noSplash -headless \
   -application org.eclipse.ant.core.antRunner \
   -buildfile $SCRIPTPATH/eclipse-mirror.xml \
   server-tools
esac;

