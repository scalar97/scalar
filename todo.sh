RED="\033[1;31m"
BLK="\033[1;30m"
RST="\033[1;0m"
U="\033[4m"
case "$1" in
    *"APP"*) ORANGE="\033[1;33m"; BLU="\033[1;34m";;
    *"TASK"*) ORANGE="\033[1;32m";BLU="\033[1;35m";;
    *"FEATURE"*) ORANGE="\033[1;106m"; BLU="\033[0;32m";;
esac
printf "$RED\rTODO$RST : $ORANGE$1$RST$BLK\tNAME$RST: $BLU$U$2$RST\t$BLK DESC$RST: $3\n" >> ~/.todo
