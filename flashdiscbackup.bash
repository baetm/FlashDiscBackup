#! /bin/bash 

# ---------------------------------------------------------------------
# FlashDiscBackup - Bash shell script to make backup for important 
# data and store in pendrive, memory card or disc

# Copyright 2022, Bartosz Etmanski

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License at <http://www.gnu.org/licenses/> for
# more details.

# Usage: TO DO

# Revision history
# 2022-06-16 Created
# ---------------------------------------------------------------------

### VARIABLES 

# backup list of catalogues
name_backup_file_list="lst_test.txt"

# path to the where pendrive should be mount
flashdisc_path=/media/$USER
disc_name=806E-B46B

# list of flashdisc catalogues 
CATALOGUES=()

# include option
flag_process=0

# if backup is doing first time
first_time=0
first_time_catalogue=''

### FUNCTIONS 

# check if pendrive is mounted
check_if_pendrive_mount() 
{
	cd $flashdisc_path 
	
	# if [ "$(ls $disc_name)" == "System Volume Information" ]; then
	if [ -d $disc_name ]; then
		echo "Disc is mounted"
	else
		echo "Disc is not mounted."
	        echo "Try to mount flash disc and run this script one more time"
		echo "Exit script."
		exit
	fi

	cd $MY_PATH 
}

# creates temporary flash disc array of catalogue
flash_disc_catalogues(){

	# creates temporary list of catalogues
	ls $flashdisc_path/$disc_name > flashdisc_catalogues.tmp 

	# add names of catalogues to array
	while read line; do
		CATALOGUES+=("$line")
	done < flashdisc_catalogues.tmp 

	# echo ${CATALOGUES[@]}

	# delete temprary list file
	 rm flashdisc_catalogues.tmp 
}

# read file with paths and check if catalogs exists
check_if_path_exists(){

	if [ -d $line ]; then
		echo "Directory exists"
		flag_process=0
	else
		flag_process=1
	fi	
}

# split the backup catalogue name in path
name_backup_catalogue(){
	
	if [ "$flag_process" -eq 0 ]; then
		catalogue_name=$(basename "$line")
	fi
}

# check if catalogue is backup first time or not
first_time_backup(){

	# check if catalogue was backed up in the past
	for catalogue in "${CATALOGUES[@]}"
	do
		if [[ "$catalogue_name.tar.gz" =~ "$catalogue" ]]; then
			first_time=0
			update_archive="$catalogue_name.tar.gz"
		else
			first_time=1
			first_time_catalogue="$catalogue_name"
		fi
	done	
}


# Create first archive if the catalogue is not exist in the flashdisc 
create_first_archive(){
	
	# check if catalogue is new
	if [ "$first_time" -eq "1" ] && [ "$flag_process" -eq "0" ]; then
	       tar cvf "$first_time_catalogue.tar" $MY_PATH/test/$fist_time_catalogue/ 
	       gzip "$first_time_catalogue.tar" 
	       rm "$first_time_catalogue.tar" 
	       cp "$first_time_catalogue.tar.gzp" $flashdisc_path/$disc_name/

	       # echo "$first_time_catalogue"
	       # echo "$line"
	fi
}

update_old_archive(){

	# copy old archive from flashdisc to PC catalogue
	if [ "$first_time" -eq "0" ] && [ "$flag_process" -eq "0" ]; then
		catalogue_date=$(date +%F -r $line)
		archive_date=$(date +%F -r $flashdisc_path/$disc_name/$update_archive)

		if [[ "$catalogue_date" > "$archive_date" ]]; then
			 echo "Make a archive"
			 tar cvf "$catalogue_name.tar" $line 
			 gzip "$catalogue_name.tar" 
			 rm  $flashdisc_path/$disc_name/$catalogue_name.tar.gz
			 mv $catalogue_name.tar.gz $flashdisc_path/$disc_name/
		 else
			 echo "Do not need to update catalogue $catalogue_name."
		fi	       
	fi
}


### MAIN 

# set the work path
MY_PATH=$(pwd) 
echo "$MY_PATH"

check_if_pendrive_mount
flash_disc_catalogues

# return to the work path
cd $MY_PATH

while read line; do
	check_if_path_exists
	name_backup_catalogue
	first_time_backup
	create_first_archive
	update_old_archive
done <$name_backup_file_list

echo "End of script"
