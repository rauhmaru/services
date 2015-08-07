#!/bin/bash
# Backup do Tomcat
# Raul Liborio raul.liborio@solutis.com.br
# 03-03-2011
DATA=`date +%x`
TOMCATBKP=${DATA}_tomcat.tar.gz
DESTINO=$1

[-d $DESTINO ] || mkdir -p $DESTINO
cd $DESTINO

service tomcat6 stop
tar cvjf $TOMCATBKP /opt/tomcat6
sleep 5
mv $TOMCATBKP /backup/srvarquivos
service tomcat6 start
