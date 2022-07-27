#! /bin/bash -x

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

	echo ${CATALOGUES[@]}

	# delete temprary list file
	rm flashdisc_catalogues.tmp 
}

# read file with paths and check if catalogs exists
check_if_path_exists(){

	if [ -d $line ]; then
		echo "Directory exists"
	else
		echo "$line does not exist"
		flag_process=1
	fi	
}

# split the backup catalogue name in path
name_backup_catalogue(){
	
	if [ "$flag_process" -eq 0 ]; then
		catalogue_name=$(basename "$line")
		echo $catalogue_name
	fi
}

# check if catalogue is backup first time or not
first_time_backup(){

	# check if catalogue was backed up in the past
	for catalogue in "${CATALOGUES[@]}"
	do
		echo "$catalogue"

		if [[ "$catalogue" =~ "$catalogue_name"_* ]]; then
			echo "$catalogue_name is found"
		else
			echo "$catalogue_name is not found"
		fi
	done	
}


# TODO 
# create_archives(){
	# TODO	
# }

### MAIN 

# set the work path
MY_PATH=$(pwd) 
echo "$MY_PATH"

check_if_pendrive_mount
flash_disc_catalogues

# return to the work path
cd $MY_PATH

while read line; do
	echo "$line"
	check_if_path_exists
	name_backup_catalogue
	first_time_backup
done <$name_backup_file_list

# echo ${PATHS[@]}

