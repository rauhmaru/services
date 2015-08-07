#! /bin/bash
# Script pro ElCheVive68!
#  O script faz umas paradas loucas mano,
# Raul Liborio, rauhmaru@opensuse.org
# Seg 14 Mar 2011 01:56:27 BRT 
# -----------------------------------------
# $IDIOMA esta dentro de cada $DIR
DIR="book-gnome book-kde book-applications"
IDIOMA="es es_ES fr it pt_BR"
# -----------------------------------------
# X navega por $DIR
# m é seu contador
for X in $DIR; do
   X[m]=${X}
   let m++

# Y navega por $IDIOMA
# n é seu contador
   for Y in $IDIOMA; do
      Y[n]=${Y}   
   	let n++
   	
	for i in $X/$Y/*.po; do
	   echo "Dir:	$X"
	   echo "Lang:	$Y"
	   echo "File:	$i"
	   echo -------
	   # Bom, esse trecho louco ../templates/${i/.po/.pot} eu nao tinha
	   #  entendido bem, mas acho que isso resolve:
	   msgmerge --previous $X/$Y/$i $X/templates/${i/.po/.pot} > $X/$Y/$i.new
	   
	   echo "Rename: $X/$Y/$i.new -> $X/$Y/$i"
	   mv $X/$Y/$i.new $X/$Y/$i
	done
   done
done
