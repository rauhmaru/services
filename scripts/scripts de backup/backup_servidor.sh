#!/bin/sh
#
# backup v1.2
#
# deizeppe@terra.com.br
#

DIR_ORIG=$1
DIR_BACKUP=$2
LOG=$2/log.$3`date +%Y_%m_%d`.log
MAIL=$2/mail.$3`date +%Y_%m_%d`.mail

[ -f $MAIL ] || touch $MAIL

if [ "$#" != 3 ]

then
   echo "USE"
   echo "EXEMPLO: $0 <DIR> ORIGEM-BACKUP <DIR> DESTINO-BACKUP NOME-DA-PASTA" 
   echo ""
   exit
fi

BKP_NAME="bkp.$3."
BKP_EXT=".tar.gz"

# compactação do diretório de origem
#tar -czpf ./${BKP_NAME} ${DIR_ORIG}
tar zvcf $DIR_BACKUP/${BKP_NAME}`date +%Y_%m_%d`${BKP_EXT} ${DIR_ORIG} 2>&1 | tee -a $LOG $MAIL > /dev/null


# mensagem de resultado
echo "####################################" | tee -a $LOG $MAIL > /dev/null
echo "Seu backup foi realizado com sucesso." | tee -a $LOG $MAIL > /dev/null
echo "Diretório origem:  ${DIR_ORIG}" | tee -a $LOG $MAIL > /dev/null
echo "Diretório destino: ${DIR_BACKUP}" | tee -a $LOG $MAIL > /dev/null

cat $MAIL | mail -s "Log do backup $3 do dia `date +%Y_%m_%d`" root


