#! /bin/bash
# Concatena arquivos
SAIDA="saida.ini"

rm $SAIDA

for i in $*; do
	echo "[$i]" >> $SAIDA
	cat -n $i | sed 's/^[ \t]*//;s/[ \t]/=/;s/[=]$//' >> $SAIDA
done

