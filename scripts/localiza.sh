#!/bin/bash
# RAUHMARU SCRIPT DIVISION :D - 05/06/08
# V2 - 08/06/08
# Lista arquivos que sao inuteis ao ambiente por norma da empresa
MSG="EXECUTE COMO ROOT. SAINDO..."

# -- VARIAVEIS --
# -- EXTENSOES DE ARQUIVOS A SEREM BUSCADAS:
LISTA="avi mp3 ogg mp4 wav wmv wma html htm asp aspx jpg png gif"

RELATORIO="/tmp/remover.csv"	# NOME DO ARQUIVO PARA O RELATORIO
ERROS="/tmp/erros.txt"	# ARQUIVO COM OS ERROS ENCONTRADOS NA BUSCA
I=0

clear

# -- VOCE EH O ROOT?
if test "$UID" != "0"; then
	echo $MSG
	exit 1
fi

# -- TAMANHO A BUSCAR
echo -n "TAMANHO DOS ARQUIVOS: " && read TAM

# -- O 'k' TEM DE SER MINUSCULO E OS OUTROS MAIUSCULOS
TAM=$( echo $TAM | tr m M | tr K k | tr g G )

# -- IMPRIMA NA TELA E NO ARQUIVO
echo "Procurando arquivos maiores que $TAM"
rm -f $RELATORIO
echo "Procurando arquivos maiores que $TAM" > $RELATORIO

# -- BUSCA CERIFICANDO A VARIAVEL $LISTA
for BUSCA in $LISTA; do
	BUSCA[I]=${BUSCA}
	I=$(echo ${I}+1 | bc)
	echo $BUSCA "-> listando e adicionando em $RELATORIO"

	find $1 -name "*.$BUSCA" -size +$TAM -printf "%kk\t%p\n" >> $RELATORIO 2>> $ERROS
	echo " ------ ------ ------ ------ -----------"
done

# -- PERFUMARIA
LINHA=$( wc -l $RELATORIO | cut -d' ' -f1 )
if test "$LINHA" = "1"; then
	echo "Nenhum arquivo encontrado."

elif test "$LINHA" = "2"; then
	echo "1 arquivo encontrado."

elif test "$LINHA" > "2"; then
	echo "$LINHA arquivos encontrados."
fi
echo
