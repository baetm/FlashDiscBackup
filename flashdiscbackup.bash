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

# Usage: 
# To run the script you should download the project from the GitHub page and move to
# destination place. Next, you should check the name of the flashdisc. In this
# case, you should check the mount catalogue. For example, for Ubuntu will
# be the /media/name-of-user/. If you find the name of the flashdisc
# then it should open flashdiscbackup.bash file, find in the VARIABLES
# section disc_name variable. After the = should add the name of
# flashdisc and check the path of the mount.
#
# flashdisc_path=/media/$USER
#
# disc_name=name-of-flashdisc
# 
# After that, there should be a prepared list of the absolute paths to backup on
# the flashdisc in any text editor e. g.
# 
# /home/user-name/Documents/
# /home/user-name/Music/
#
# The name of the list of backup catalogues should be added to VARIABLE
# section in flashdiscbackup.bash (name_backup_file_list) in the same
# way like flashdisc before. The list has to be in the same catalogue as a script file..
# 
# When you prepare the list file and add all names, the next step is to add
# the privilege of running on your system in the next command in a terminal 
# emulator:
#
# $ sudo chmod +x flashdiscbackup.bash
#
# and then it may run the script in command:
# 
# $ ./flashdiscbackup.bash

# Revision history
# 2022-06-16 Created
# 2022-08-31 Version: 1.0
# 2022-09-01 Version: 1.1
# ---------------------------------------------------------------------

### VARIABLES 

# backup list of catalogues
name_backup_file_list="list-of-catalogues.txt"

# path to the where pendrive should be mount
flashdisc_path=/media/$USER
disc_name=name-of-flashdisc 

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
	       echo "Tar archive creating..."
	       tar cvf "$first_time_catalogue.tar" $line 
	       echo "Creating is done."
	       echo "Gzip archive creating..."
	       gzip "$first_time_catalogue.tar" 
	       echo "Creating is done."
	       echo "Copying archive to flashdisc..."
	       cp "$first_time_catalogue.tar.gz" $flashdisc_path/$disc_name/
	       echo "Copying is done."
	       echo "Remove old archive"
	       rm "$first_time_catalogue.tar.gz" 
	       echo "Removing is done."
	fi
}

update_old_archive(){

	# copy old archive from flashdisc to PC catalogue
	if [ "$first_time" -eq "0" ] && [ "$flag_process" -eq "0" ]; then
		catalogue_date=$(date +%F -r $line)
		archive_date=$(date +%F -r $flashdisc_path/$disc_name/$update_archive)

		if [[ "$catalogue_date" > "$archive_date" ]]; then
			 echo "Making a tar archive..."
			 tar cvf "$catalogue_name.tar" $line 
			 echo "The tar archive was done"
			 echo "Making a gzip archive..."
			 gzip "$catalogue_name.tar" 
			 echo "The gzip archive was done"
			 echo "Deleting old archive in the flashdisc..."
			 rm  $flashdisc_path/$disc_name/$catalogue_name.tar.gz
			 echo "Delete was done"			
			 echo "Moving new archive to the flashdisc..."
			 mv $catalogue_name.tar.gz $flashdisc_path/$disc_name/
			 echo "Move was done"
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
