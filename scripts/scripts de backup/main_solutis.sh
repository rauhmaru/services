#!/bin/bash
# Script de Inicializacao de backups
# Raul Liborio, raul.liborio@solutis.com.br
# 11-03-2011
# v.02 - Qua 20 Abr 2011 16:08:42 BRT 

DATA=`date +%d-%m-%Y`
BKPDIR="/backup/srvarquivos/$DATA"
LOCAL="/backup/Diario"
LOG="/var/log/backup/$DATA"
ADMINBKP="raul.liborio@solutis.com.br"
CCMAIL="mauricio.martins@solutis.com.br"
SERVERLIST="/etc/SERVIDORES.txt"
ERR1="\n\nLista de servidores nao encontrada. verifique se o arquivo $SERVERLIST existe.\n\n"
#------------------
# Em um laço, verifique no arquivo quais serão os
## servidores que entraram no backup e starte os
## scripts de backup.


# Verifique se a lista de servidores existe
[ -e $SERVERLIST ] || { echo -e $ERR1 ; exit 1; }

# Main do script
for SERVIDOR in `cat $SERVERLIST | egrep -v "#|^$"` ; do
[ -d $LOG/$SERVIDOR ] || mkdir -p $LOG/$SERVIDOR
   echo "Conectando em $SERVIDOR"
   ssh -t root@$SERVIDOR \
        bash -x /etc/$SERVIDOR.sh \
          >>  $LOG/$SERVIDOR/$SERVIDOR.log \
          2>> $LOG/${SERVIDOR}/err_${SERVIDOR}.log

# Busque o backup no servidor e armazene
   [ -d $LOCAL/$SERVIDOR ] || mkdir -p $LOCAL/$SERVIDOR
   scp -r $SERVIDOR:$BKPDIR $LOCAL/$SERVIDOR/
   echo -e "Backup em $SERVIDOR realizado com sucesso!\n"


# Se ocorrer algum erro, mande um email para os administradores
   LINHA=$( wc -l $LOG/${SERVIDOR}/err_${SERVIDOR}.log | cut -d' ' -f1 )
   if test "$LINHA" -gt "1"; then
      cat $LOG/${SERVIDOR}/err_${SERVIDOR}.log | \
        mail -s "$SERVIDOR: Debug em backup `date +%d-%m-%Y`" \
        $ADMINBKP -c $CCMAIL
   fi
done
