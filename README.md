ShellUtils
========

Some random shell scripts written to make my life bit easier.

### push & pop
Shows a numbered list of saved directories and cd to the selected directory. Push will remember the current directory and pop[1] will cd to the selected directory. 
Create two aliases as follows :

alias pop='. ~/bin/pop.sh'

alias push='~/bin/push.sh'

[1] In order to cd, the pop script will have to be executed in the current shell. 

### pushPop.rc : push & pop on steroids
Add these shell functions to .bashrc or .profile. 
pop N will cd to the Nth directory in the list.

### mpdLyrics.sh

Create the lyrics file for mpd from the current song's id3 tags.

### backupScript.sh
Backup data using rsync. The directories to backup and the destinations are read from a control file.

#### Control File
The control file fields are separated by pipes (|). Lines starting with # characters are ignored.

The modified/deleted files are moved to the directory pointed by the CTRL|CTRL|backupdir entry.

CTRL|backupdir|/destinationFolder/deletions/

A Sample Control file:
```
CTRL|backupdir|/destinationFolder/deletions/
sourceFolder1/|destinationFolder1/
sourceFolder2/|destinationFolder2/
```

#### Running backupScript.sh
backupScript profileFile

### srchEpub.sh
Search for a pattern in epub files which are listed in the input file.

#### Running srchEpub.sh
srchEpub.sh fileContainingNamesOfEpubsToSearch SearchString

### slCodeGen.sh
Generate C code for SQLite dynamic binding

#### Running slCodeGen.sh

slCodeGen.sh configFile

##### Sample Config file
```
# Comments start with #
#Query
query|select path from tab1 where stat = 1 order by size

#Name of the statement
name|fetchData

#Name of the Db Handle
db|dbRecPtr->fileDb

#int Variable
int|id

# String variable with size 30
str|col1|30
```

### up.rc : Shell function to go n level up in the directory structure
Add this shell functions to .bashrc or .profile. To move 3 level up in
the directory structure, invoke up 3. If n is largern than the directory
level depth, will end up in /
