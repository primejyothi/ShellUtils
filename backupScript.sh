#! /usr/bin/env bash
# 
# Script to back up data using rsync.
# Read the source and destination folders from a profile file
# which is given as the argument to the script.

# The profile file has the following format, lines starting with # are ignored.
# The fields are separated by pipe symbols. 
#
# The rsync command is run with backup and backup-dir option due to which
# the changed/deleted files will be moved to a sub folder specified by the
# backupdir entry in the profile file.
#
# CTRL|backupdir|/destinationFolder/deletions/
# sourceFolder1/|destinationFolder1/
# sourceFolder2/|destinationFolder2/
#	.
#	.
#	.
# sourceFolder999|destinationFolder999

# Author	: Prime Jyothi, http://primej.blogspot.com


if [[ -z "${LOGDIR}" ]]
then
	# Set the default log directory.
	LOGDIR="${HOME}/backupLogs"
fi

if [[ ! -d "${LOGDIR}" ]]
then
	echo "Log : Unable to access log directory ${LOGDIR}, using $PWD"
	LOGDIR=${PWD}
fi

logFile="${LOGDIR}/backup.`date \"+%Y%m%d%H%M%S\"`.log"
backupSuffix=.bkup.`date "+%Y%m%d%H%M%S"`

if [[ "$#" -ne 1 ]]
then
	echo "usage : `basename $0` Profile_File"
	exit 1
else
	profileFile=$1
	if [[ ! -r ${profileFile} ]]
	then
		echo "Unable to read profile file ${profileFile}"
		exit 2
	else
		echo "Log : Profile file is ${profileFile}"
	fi
fi

# Read the control data from the profile file
bkupDir=`grep '^CTRL|backupdir|' ${profileFile} | awk -F"|" '{print $3}'`

if [[ ! -d ${bkupDir} ]]
then
	echo "Unable to access backup directory ${bkupDir}"
	echo "Check entry CTRL|backupdir|<directoryName> in profile file"
	exit 3
fi

bkSubDir=${bkupDir}/`date "+%Y%m%d%H%M%S"`
echo "Log : Backup Sub Dir is ${bkSubDir}"

syncCmd="rsync -avv --log-file=${logFile} --backup --backup-dir=${bkSubDir} --delete "

echo "Log : Deleted or changed file will be moved to ${bkSubDir}"
echo "Log : rsync log messages will be logged to ${logFile}"

oldIFS=$IFS
IFS='
'
startTime=`date`
for i in `cat ${profileFile} | grep -v "^#" | grep -v "^CTRL|"`
do
	IFS=$oldIFS
	src=`echo "$i" | awk -F"|" '{print $1}'`
	dest=`echo "$i" | awk -F"|" '{print $2}'`
	echo "Log : Source : ${src}, Destination : ${dest}"
	sleep 1

	${syncCmd} "${src}" "${dest}"
done

# Repeating few info, but will be handy when using tail to see the log file.
echo "Log : Profile file is ${profileFile}"
echo "Log : Backup Sub Dir is ${bkSubDir}"
echo "Log : Log file is ${logFile}"
echo "Log : started  at $startTime"
echo "Log : Finished at `date`"
echo "Log : Failures ================================="
grep -i -e fail ${logFile}
exit
