#! /bin/bash -e
# Backup do Tomcat
# Raul Liborio raul.liborio@solutis.com.br
# 03-03-2011
DATA=`date +%x`
TOMCATBKP=${DATA}_tomcat.tar.gz

[-d /backup/srvarquivos ] || mkdir -p /backup/srvarquivos
cd /backup/srvarquivos

service tomcat6 stop
tar cvjf $TOMCATBKP /opt/tomcat6
sleep 5
mv $TOMCATBKP /backup/srvarquivos
service tomcat6 start


# no cron, execute as 23:30 todos os dias
30 23 * * * /etc/smartenergia-pge.sh

# /etc/fstab
//10.0.10.13/10.0.11.133 /backup/srvarquivos     cifs    defaults,user=backupsolutis,password=BKP83u1s0lut1s     0 0


# BKP TOMCAT & POSTGRES
DATA=`date +%F` # Atencao aqui!!!
TOMCATBKP=${DATA}_tomcat.tar.bz2
BKPDIR="/backup/srvarquivos"
[-d $BKPDIR ] || mkdir -p $BKPDIR
cd $BKPDIR
service tomcat6 stop
tar cvjf $TOMCATBKP /opt/tomcat6
sleep 5
mv $TOMCATBKP $BKPDIR
service tomcat6 start
sudo -u postgres pg_dumpall | gzip > $BKPDIR/${DATA}_pgdb.gz

#------------------------
# Bakcup do subversion / Redmine
# Raul Liborio raul.liborio@solutis.com.br
# 09-03-2011

DATA=`date +%x`
IMPROVEMENT="/var/www/svn/improvement"
SOLUTIS="/var/www/svn/solutis"
BKPDIR="/backup/srvarquivos/$DATA/SVN"
BKPSOLUTIS="$BKPDIR/SOLUTIS"
BKPIMPROVEMENT="$BKPDIR/IMPROVEMENT"
BKPREDMINE="/backup/srvarquivos/$DATA/REDMINE"
HTTPD="/var/run/httpd.pid"
#-----------------------------------

# backup svn solutis 
SOLUTIS(){
  [ -d $BKPSOLUTIS ] || mkdir -p $BKPSOLUTIS
  cd $SOLUTIS
  for PROJETO_SOLUTIS in `ls` ; do
        svnadmin dump $PROJETO_SOLUTIS > $BKPSOLUTIS/${DATA}_$PROJETO_SOLUTIS.dump
        echo "$PROJETO_SOLUTIS SENDO ALOCADO EM $BKPSOLUTIS/${DATA}_$PROJETO_SOLUTIS.dump"
  done
}
#-----------------------------------

# backup svn improvement
IMPROVEMENT(){
  [ -d $BKPIMPROVEMENT ] || mkdir -p $BKPIMPROVEMENT
  cd $IMPROVEMENT
  for PROJETO_IMPROVEMENT in `ls` ; do
        svnadmin dump $PROJETO_IMPROVEMENT > $BKPIMPROVEMENT/${DATA}_$PROJETO_IMPROVEMENT.dump
        echo "$PROJETO_IMPROVEMENT SENDO ALOCADO EM $BKPIMPROVEMENT/${DATA}_$PROJETO_IMPROVEMENT.dump"
  done
}
#-----------------------------------

REDMINE(){
  echo "Backup Redmine"
  [ -d $BKPREDMINE ] || mkdir -p $BKPREDMINE
  /opt/redmine-1.0.1-0/ctlscript.sh stop
  tar cjvf $BKPREDMINE/${DATA}_REDMINE.tar.bz2 /opt/redmine-1.0.1-0/
  /opt/redmine-1.0.1-0/ctlscript.sh start

}

#-----------------------------------
# MAIN

[ -f $HTTPD ] && service httpd stop
SOLUTIS
IMPROVEMENT
REDMINE
service httpd start
