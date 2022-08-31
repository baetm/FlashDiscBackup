# FlashDiscBackup
Simple scripts to create fast backup on the flashdisc (pendrive).

## Table of contents
 * General Info
 * Technologies
 * Setup
 * Status
 * Sources

## Introduction
This script was created when the author needed easy backup every day in
GNU/Linux distributions. The Linux distribution offers many tools, but there
were not universal for every distribution or desktop environment. The idea
is created simple bash script which will be made every day backup on pendrive
for important catalogues.

## Technolgies
Project is created with:

* Bash version: 5.1.16

## Setup
To run the script you should download the project from the GitHub page and move to
destination place. Next, you should check the name of the flashdisc. In this
case, you should check the mount catalogue. For example, for Ubuntu will
be the **/media/name-of-user/** . If you find the name of the flashdisc
then it should open **flashdiscbackup.bash** file, find in the VARIABLES
section **disc_name** variable. After the **=** should add the name of
flashdisc and check the path of the mount.

```
flashdisc_path=/media/$USER

disc_name=name-of-flashdisc
```

After that, there should be a prepared list of the absolute paths to backup on
the flashdisc in any text editor e. g.

```
/home/user-name/Documents/

/home/user-name/Music/
```

The name of the list of backup catalogues should be added to **VARIABLE**
section in **flashdiscbackup.bash** (**name_backup_file_list**) in the same
way like flashdisc before. The list has to be in the same catalogue as a script file..

When you prepare the list file and add all names, the next step is to add
the privilege of running on your system in the next command in a terminal 
emulator:

```
$ sudo chmod +x flashdiscbackup.bash
```

and then it may run the script in command:

```
$ ./flashdiscbackup.bash
```

## Status
The first version of the script is done, but there is more functionality
to add to this project in the future.

TO DO a list of functions:

* add to read the name of the flashdisc and list of catalogues like input
parameters,
* add the check for free size on the flashdisc,
* add to choose the criptography of the catalogues,
* recognize if catalogues are video content, graphics or audio files.

## Sources
This script is inspired by William Shotts' book 
"The Linux Command Line".
