#!/bin/sh
#
#    makediffv2.sh
#    Warren Brown 20171006
#    University of Florida Fall 2017 COP4600 Project 1
#
#	https://github.com/protodrone/COP4600P1-makediff
#
#	This work is licensed under a 
#	Creative Commons Attribution 4.0 International License
#	http://creativecommons.org/licenses/by/4.0/
#
# 	For the shell script to work, it needs the following:
# 	* Your modified source code/tree should be in /usr/src/
# 	* The original (unmodified) Minix source code/tree should be in /usr/src_original
#	* A text file, named filelist.txt, should be in the same directory as the makediffv2.sh script
#		* An example filelist.txt is included in the repo.
#		* Ensure the filelist.txt has only one file, with full path, on each line
#		* Do not include a trailing line/empty line at the end
#		* Order does not matter within filelist.txt
#		* Edit/create filelist.txt in Minix. Windows uses different end of line characters (e.g. nano filelist.txt)

TEMPFILES="sedtemp.txt newfiles.txt newfilestemp.txt existingfilesorig.txt existingfiles.txt existfilediffstub.txt"

if [ -e p1diff.txt ]
then
	rm p1diff.txt
else
	touch p1diff.txt
fi

rmTempFiles()
 {
	for fileName in $TEMPFILES
	do
		if [ -e $fileName ]
		then
			rm $fileName
		fi 
	done
}

rmTempFiles

sed 's/src/src_original/' filelist.txt > sedtemp.txt

while read f; do
	
	if [ -e $f ]
	then
		echo $f >> existingfilesorig.txt 
	else
		echo $f >> newfilestemp.txt
	fi
done <sedtemp.txt

sed 's/src_original/src/' newfilestemp.txt > newfiles.txt
sed 's/src_original/src/' existingfilesorig.txt > existingfiles.txt
paste existingfilesorig.txt existingfiles.txt > existfilediffstub.txt

while read j; do
# This part could use some love to make the script play better with
# empty lines in the file list. I thought it would be simple, but it wasn't.
# feel free to fix and contribute a pull request.
#	if [ -z $j ]
#	then
#		echo "Skipping empty line."
#	else
		echo "diff -uN $j >> p1diff.txt"
        	diff -uN $j >> p1diff.txt
#	fi
done <existfilediffstub.txt

while read k; do
	if [ -z $k ]
	then
		echo "Skipping empty line."
	else
		echo "diff -u --unidirectional-new-file /dev/null $k >> p1diff.txt"
		diff -u --unidirectional-new-file /dev/null $k >> p1diff.txt
	fi
done <newfiles.txt

rmTempFiles





