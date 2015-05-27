#!/bin/bash

if [ $# -ne 2 ]
then
	echo "Usage: remove-diacritics.sh [INFILE] [OUTFILE]"
	echo "INFILE has to be in the tab format. OUTFILE will be truncated."
	exit 1
fi

rows=`wc -l $1 | cut -d ' ' -f 1`
rm -f $2
iteration=0

while IFS=$'\t' read word definition
do
	let "iteration++"
	echo -ne "Processing entry ${iteration}/${rows}\r"
	clean_word=`echo -e $word | perl -CS -MUnicode::Normalize -pne '$_=NFKD($_);s/\p{InDiacriticals}//g'`
	echo -e "$clean_word\t<h2><i>$word</i></h2><br>$definition" >> $2
done < $1
echo -e "\033[2KProcessing done!"
