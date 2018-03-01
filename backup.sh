# Bash script to backup my config files from my Linux to 
# my windows partition.
# I can now just edit the $CONFIG_FILE to add files that 
# will always be backed up every time I run this script

# Author : Tatiana Zihindula

readonly BACKUP_DIR="/run/media/tati/F656D5C556D586B1/Users/tati/LINUX"
readonly CONFIG_FILE="$HOME/.backup"

[ -d $BACKUP_DIR ] || mkdir -p $BACKUP_DIR

argv=$@ && [[ ${1:0:1} == '-' ]] && option=$1

function backup( )
{
	local file_name=$1
	# use either regular file, or directory specific options
	[ -d $file_name ] && cp -Rufp $file_name $BACKUP_DIR
	[ -f $file_name ] && cp -puf  $file_name $BACKUP_DIR
}

if [ $# -gt 0 ] ; then
	# backup passed argument files 
	while [[ $# > 0 ]]; do
		  backup $1
		  shift
	done
	
	# save arguments to file only if explicitly specified with -p
	if [[ $option == *'p'* ]]; then
		for file in $argv; do
			
			# only save files that have never been saved before
			if [ -e $file ] && ! grep -xq $file $CONFIG_FILE; then
				
				#expand the file to its full path then write it to $CONFIG_FILE
				readlink -m  $file  >> $CONFIG_FILE
			fi
		done;
	fi
else
	# No arguments, then backup from config file only if it already exist
	[ -f $CONFIG_FILE ] || { echo "Error: No config file">&2 && exit 1;}
	
	while read -r file_name; do
		# pass the file_name to the backup function
		backup $file_name
		
	done < $CONFIG_FILE
fi

exit 0
