#!/bin/bash
# Script to download contigs  data from https://ibdmdb.org/

# The file is the html file from ibdmb
file=$1

# Control number of arguments. The argument must be an existing file

if [[ $# < 1 ]]; then
	echo "error:too few arguments. You must provide the html file (in .txt) as an argument"
	exit
fi

# Check if the file with the URLs that we are ging to create exists

if test -f "URL_${file}"; then
        echo "URL_${file} already exists, it will be overwritten"
	rm -r URL_${file}
fi

# Get the URLs from the .txt files (they come from the html)
cat $file | grep '_contigs.fna.gz'| awk -F'"' '/<a href=/ {print "https://ibdmdb.org"$2}' > URL_${file}

# We create a directory where we are going to store the files that we are going to download
project_name="downloads_"${file%.txt}

if [ -d $project_name ]; then
	echo "$project_name directory already exists"
	echo -e "Do you want to overwrite the directory?[Y/N] \nWARNING: all the content from the directory will be deleted"
	read ans
	case $ans in
		"Y") rm -r $project_name;; #the previous directory with the same name will be deleted
		"N") echo "We cannot proceed with the code"; exit ;;  #the program exits
	esac
else
	mkdir $project_name 
fi

# We read the document line by line and download the data
while read url; do
	wget --no-check-certificate -P ./$project_name $url
done <URL_${file}


