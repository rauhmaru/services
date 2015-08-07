#!/bin/bash
# novo escalonador

# -- VARIAVEIS
BOOTLOCAL=/etc/rc.d/boot.local
INSTALL="zypper in -y libcgroup1"
MSG="Apenas root pode realizar essa tarefa."
BASHRC='
if [ "$PS1" ] ; then\n
   mkdir -p -m 0700 /cgroup/cpu/user/$$\n
   echo $$ > /cgroup/cpu/user/$$/tasks\n
fi
'


# -- INSERCOES
escalonador(){
	chkconfig cgroup on
	echo "/bin/mkdir -m 0777 /cgroup/cpu/user" >> $BOOTLOCAL
	echo -e $BASHRC >> ~/.bashrc
}


# -- CORE
[ "$USER" != "root" ] && echo $MSG; exit 1
[ -f /lib/libcgroup.so.1 ] && escalonador && exit 0 || $INSTALL && escalonador && exit 0
