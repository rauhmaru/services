#! /bin/bash
# Gfxboot generator
# Raul Liborio ( rauhmaru#gmail.com) @raulliborio
#
#	premissas:
#	2. Alterar o gfxboot - obrigatorio
#	3. testar - opcional

DIR_IMAGEM=$( mktemp -d XXXXXXXXX )
TIPO_ACCEPT="image/jpeg"
ERR_DEFAULT="nao encontrado. Instale-o para continuar."
ERR_ROOT="$USER, apenas root pode executar este script."
ERR_FORMATO="Utilize apenas imagens tipo JPG. Tipo de arquivo invalido."
ERR_FORMATO_LIGHT="Este tipo de arquivo nao eh aceito pelo gfxboot."
HELP="USO: $0 [OPCAO] [IMAGEM]\n
  $0 -r IMAGEM\n
  $0 -i\n

"
#[ "$2" ] && IMAGEM_PATH=$2 && IMAGEM=$( basename $IMAGE_PATH ) || \
#IMAGEM=$( basename $IMAGE_PATH )



############################################

[ ! $UID = 0 ] && echo $ERR_ROOT && exit 1
IMAGEM_PATH=$2
IMAGEM=$( basename $IMAGE_PATH )
	
RESIZE() {
	TIPO=$( file -i $IMAGEM | cut -f1 -d/)
	if [ ! $TIPO = $TIPO_ACCEPT ]
		then
		echo $ERR_FORMATO_LIGHT
		
	else
		convert $IMAGEM_PATH -resize 800x600 800_$IMAGEM
	
	fi
	}
	
GFXINSTALL() {
	TIPO=$( file -i $IMAGEM | cut -f1 -d/)
	if [ ! $TIPO = $TIPO_ACCEPT ]
		then
		echo $ERR_FORMATO
		
	else
	
		cd $DIR_IMAGEM
		convert $IMAGEM_PATH -resize 800x600 800_$IMAGEM
		mv 800_$IMAGEM back.jpg
		gfxboot --add-files back.jpg
	
	fi
	
	}

GFXPREVIEW() {
	gfxboot --test --preview -m vbox
	}

case "$1" in
	-h) echo $HELP ;;
	-r) RESIZE ;;
	-i) GFXINSTALL ;;
	-p) GFXPREVIEW ;;
	 *) echo -e $HELP ;;
esac
