#!/bin/bash

# 2.2 - Aceita varios parametros (a pedido do Julio Neves)
# 2.1 - Exibe o endereco de todas as interfaces
# 2.0 - Mostra o endereco IP de saida
# 1.0 - Mostra o ip das interfaces

# PasteBin: http://rauhmaru.pastebin.com/d662829e0 
# Download: http://rauhmaru.pastebin.com/pastebin.php?dl=d662829e0

# -- VARIAVEIS
IFCONFIG="/sbin/ifconfig"


MODO_DE_USO="USO: $( basename $0) [ OPCAO ]|-e[ INTERFACE ]


OPCOES:
-a: Exibe o endereco IP de todas as interfaces,
inclusive o endereco externo
-e INTERFACE: Exibe o endereco IP da interface INTERFACE
-o: Exibe o endereco IP de saida
-h: Exibe esta ajuda
-v: Versao e ultima alteracao


STATUS:
0 Saida ok
1 Argumento invalido
2 Falta de argumento


IR - Interface de Rede
Visualizador simples de endereco de rede


Raul Liborio - | http://rauhmaru.blogspot.com/
http://www.redesfja.com/
"
# -- EXECUCAO

if [ -z $1 ]; then

ip a | awk "/eth0/"'{print $2}' | tail -1 | cut -d/ -f1
exit 0

else

IP_EXTERNO(){
w3m -dump http://www.whatismyip.com | sed -n 's/Your\ IP\ Address\ Is: //p'
}

while getopts ":ahove:" ARGUMENTOS
do

	case "${ARGUMENTOS}" in

		h) echo "${MODO_DE_USO}"
		exit 0 ;;
	
		v) cat $( which $( basename $0 ) ) \
		| awk -F# "/[0-9]/"'{ print $2 }' | head -1
		exit 0;;

		a) LANG=POSIX ${IFCONFIG} | awk "/inet addr:/"'{ print $2 }'\
		| cut -d: -f2; IP_EXTERNO
		exit 0;;
	
		e) ip a show "$OPTARG" | awk /inet/'{ print $2 }'| \
		head -1 | cut -d/ -f1;;
	
		o) IP_EXTERNO;;
	
		\?) echo "${MODO_DE_USO}"
		exit 1;;
	
		:) echo sim... e a INTERFACE? Esqueceu foi? cabeca... :P
		exit 2;;

	esac

done

fi
