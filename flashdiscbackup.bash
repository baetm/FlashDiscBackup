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
name_backup_file_list='lst_test.txt'

# path to the where pendrive should be mount
path=/media/$USER
disc_name=806E-B46B

### FUNCTIONS 
check_if_pendrive_mount() 
{ 
	cd $path 
	
	if [ "$(ls $disc_name)" == "System Volume Information" ]; then
		echo "Disc is mounted"
	else
		echo "Disc is not mounted."
		echo "Exit script."
		exit
	fi
}

### MAIN 

check_if_pendrive_mount
