#! /usr/bin/env bash

# Script to generate SQLite Code for dynamic binding
# primejyothi at gmail dot com  20130716
# License : GPLv3

if [[ "$#" -ne 1 ]]
then
	echo "Usage : `basename $0` configFile"
	cat <<- end

	Sample Config file
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
	end
	exit 1
fi

cFile=$1

oldIFS=$IFS
IFS='
'
for i in `cat ${cFile} | grep -v '^#'`
do
	key=`echo $i | awk -F"|" '{print $1}'`
	# echo key = $key
	val=`echo $i | awk -F"|" '{print $2}'`
	# echo val = $val
	size=`echo $i | awk -F"|" '{print $3}'`
	# echo size = $size
	
	# Parse the values.

	case "${key}" in 
	"name")
		stmtName=${val}
		;;
	"query")
		query=${val}
		;;

	"int" )
		ints=`echo ${ints} ${val}`
		;;
	"str" )
		strs=`echo "${strs}${val}|${size} "`
		;;
	"db" )
		dbName=${val}
		;;
	esac
done

echo "/* Declarations */"

IFS=$oldIFS
for k in ${ints}
do
	echo "int $k;"
done
echo
echo "int retval;"
echo "int idx;"

echo 

for k in ${strs}
do
	var=`echo $k|awk -F"|" '{print $1}'`
	size=`echo $k|awk -F"|" '{print $2}'`
	echo "char $var[$size];"
done

echo 

echo "sqlite3_stmt *$stmtName;"
echo "const char *${stmtName}Trail;"

# Prepare statement

echo 

echo "retval = sqlite3_prepare_v2 (${dbName}, \"${query}\","
echo "-1, &${stmtName}, &${stmtName}Trail);"

cat << end
if (retval != SQLITE_OK)
{
	printf ("Error while sql prepare, %d, %s\n",
	retval, sqlite3_errmsg ($dbName));
	/* Error handling goes here... */
}

end

for i in ${ints}
do
cat << end
idx = sqlite3_bind_parameter_index (${stmtName}, ":${i}");
if (!idx)
{
	printf ("Error while looking up ${i}\n");
	/* Error handling goes here... */
}

retval = sqlite3_bind_int (${stmtName}, idx, $i);
if (retval != SQLITE_OK)
{
	printf ("Error while binding :${i}, %d, %s\n", retval,
	sqlite3_errmsg (${dbName}));
	/* Error handling goes here... */
}

end
	echo
done

for i in ${strs}
do
varName=`echo $i | awk -F"|" '{print $1}'`
cat << end
idx = sqlite3_bind_parameter_index (${stmtName}, ":${varName}");
if (!idx)
{
	printf ("Error while looking up :${varName}\n");
	/* Error handling goes here... */
}

retval = sqlite3_bind_text (${stmtName}, idx, $varName, -1, SQLITE_TRANSIENT);
if (retval != SQLITE_OK)
{
	printf ("Error while binding :${varName}, %d, %s\n", retval,
		sqlite3_errmsg ($dbName));
	/* Error handling goes here... */
}

end
done
