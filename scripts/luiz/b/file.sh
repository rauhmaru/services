#! /bin/bash
# Concatena arquivos
SAIDA_TRADUZIDA="saida-traduzida.ini"
TEMPLATE="blabla.moo"
OUT="original.ini"

#rm $SAIDA_TRADUZIDA



SESSOES=$( cat -n saida-traduzida.ini  | grep -c '\[' )
echo $SESSOES > sessoes.txt

LINHAS=$( cat -n saida-traduzida.ini | grep '\[' )
echo $LINHAS > linhas.txt

for i in $(seq $SESSOES); do
	head -$i linhas.txt > $i.txt
done




















#for i in $( egrep '^\[' $SAIDA_TRADUZIDA ); do
#	echo "[$i]" >> $SAIDA

#cat -n $i | sed 's/^[ \t]*//;s/[ \t]/=/;s/[=]$//' >> $SAIDA
#done
