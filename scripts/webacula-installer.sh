#!/bin/bash
#Instalação do webacula
# Raul Libório, rauhmaru@opensuse.org
# Seg 23 Mai 2011 01:40:15 BRT 

[ -d /etc/bacula ] || echo INSTALAÇÃO DO BACULA NAO ENCONTRADA && exit

DOMINIO="webacula@`hostname -f`"
APACHEUSER="wwwrun"
BCONSOLE=`which bconsole`
DATA=`date +%r`
IP=`ip a | awk '/eth0$/''{print $2}'`
VERSAO=`awk '/VERSION/''{ print $NF}' /etc/SuSE-brand`


# Verificacao de pendências
zypper -ar http://packman.inode.at/suse/$VERSAO/packman.repo
zypper in -y -t pattern lamp_server
zypper in -y php5-{pdo,gd,xmlreader,xmlwriter,dom,mysql,sqlite} sipcalc

NETWORKADDRESS=`sipcalc $IP | awk '/Network address/''{print $NF}'`


# Remover instalacoes antigas
cd /tmp
rm -fv Zend.tar.bz2*
rm -fv webacula-5.5*
rm -rfv /usr/share/webacula
rm -fv /etc/apache/conf.d/webacula.conf

# download do webacula (versão 5.5.0):
wget http://ufpr.dl.sourceforge.net/project/webacula/webacula/5.5.0/webacula-5.5.tar.gz
wget http://dl.dropbox.com/u/935037/ZendFramework/Zend.tar.bz2
tar xvf webacula-5.5.tar.gz
tar xvf Zend.tar.bz2 -C webacula-5.5/library/
mv -v webacula-5.5 /usr/share/webacula

cd /usr/share/webacula
install/check_system_requirements.php

# Configuracao do PHP
sed -i.$DATA '/def.timezone = "Europe\/Minsk"/d;s/\[general\]/\[general\]\ndef.timezone = "America\/Bahia"\nlocale = "pt_BR"\nmemory_limit = 32M\nmax_execution_time = 3600/' application/config.ini


# Uso do bconsole via webacula
groupadd bacula
groupmod -A wwwrun bacula
chown -v root:bacula $BCONSOLE
chmod -v u=rwx,g=rx,o= $BCONSOLE
chown -v root:bacula /etc/bacula/bconsole.conf
chmod -v u=rw,g=r,o= /etc/bacula/bconsole.conf
chown -vR /usr/share/webacula

sed -r -i.$DATA "/mod_rewrite.so/d;\
s|Allow from localhost|Allow from $NETWORKADDRESS|;\
s|^/Directory>|</Directory>|" install/apache/webacula.conf

sed -i.$DATA 's/negotiation setenvif ssl userdir php5/negotiation setenvif ssl userdir php5 rewrite/' /etc/sysconfig/apache2

cp -v install/apache/webacula.conf /etc/apache2/conf.d/ 

# Configuracao do /etc/sudoers
sed -i.$DATA 's/root    ALL=(ALL) ALL/root    ALL=(ALL) ALL\nwwwrun ALL=NOPASSWD: /sbin/bconsole' /etc/sudoers

# Configuracao de acesso ao webacula
# -- senha gerada automaticamente pela variavel $RANDOM
PASSWORD=`echo $RANDOM`

sed -i.$DATA "s|webacula_root_pwd=\"\"|webacula_root_pwd=\"$PASSWORD\"|" install/db.conf

cd install/MySql
sed -i "s/CREATE TABLE IF NOT EXISTS webacula_users/\
DROP TABLE IF EXISTS webacula_users\n\
CREATE TABLE IF NOT EXISTS webacula_users" 20_acl_make_tables.sh
./10_make_tables.sh
./20_acl_make_tables.sh
cd -

# Acesso no .htaccess
sed -i.$DATA "s|#SetEnv APPLICATION_ENV production|SetEnv APPLICATION_ENV production|;\
s|SetEnv APPLICATION_ENV development|#SetEnv APPLICATION_ENV development|" html/.htaccess



echo -e "
##############################################################################


		     WEBACULA INSTALADO COM SUCESSO




  URL: http://$IP/webacula
  LOGIN: root
  PASSWORD: $PASSWORD



##############################################################################
"
