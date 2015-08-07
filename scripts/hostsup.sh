# !/bin/bash

HOSTS=`nmap -sP $1 | awk "/^Host/"'{ print $2 }'`
GATEWAY=`netstat -rn | awk "/UG/"'{ print $2 }'`
CORES="\e[1;33m${GATEWAY}\e[0m"

[ ! -z ${GATEWAY} ] && echo -e ${HOSTS} | tr ' ' '\n' | \
	grep -v ${GATEWAY} 2&>1 || \
	echo -e ${HOSTS} | tr ' ' '\n'

[ -z ${CORES} ] && echo "Default gateway nao definido!" || \
echo -e ${CORES}



#<embed src='http://izismile.com/video/player2/player.swf' height='400' width='600' allowscriptaccess='always' allowfullscreen='true' flashvars='skin=http%3A%2F%2Fizismile.com%2Fvideo%2Fplayer2%2Fskin%2Fstylish.swf&file=http%3A%2F%2Fizismile.com%2Fimg%2Fimg2%2F20090715%2Fvideo%2F01_psycho.flv&plugins=viral-1'/>
