#!/bin/bash
SAMPLESPATH=$(pwd)
#ls $SAMPLESPATH/pdf-source/ -R
ls $SAMPLESPATH/ -R

# Do nothing if folder is empty
if (( "$(ls $SAMPLESPATH/pdf | wc -l)" == 0  )); then
#if (( "$(ls $SAMPLESPATH/pdf-source/pdf |wc -l)" == 0 )); then
	echo "Folder is empty"
else
	echo "Processing files"
	cd /peepdf
	for file in $SAMPLESPATH/pdf/*
  #for file in $SAMPLESPATH/pdf-source/pdf/*
    do
    xbase=${file##*/}; xfext=${xbase##*.}; xpref=${xbase%.*}
    echo Analysing: ${file##*/}

	  #/usr/bin/python peepdf.py $file -f -c  | sed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g" > result
	  docker run cincan/peepdf $file -f -c | sed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g" > result
		cat result | tee -a $SAMPLESPATH/peepdf.log 
	done

	# Update the results-git
	cd $SAMPLESPATH
	ls $SAMPLESPATH -R
	#git clone results output-files

	#cd $SAMPLESPATH/output-files
	#cp $SAMPLESPATH/*.log $SAMPLESPATH/output-files/results/
  cp $SAMPLESPATH/*.log $SAMPLESPATH/results/

#	git pull
	git add .
#	git config --global user.name "${GITLAB_USER_ID}"
#	git config --global user.email "${GITLAB_USER_EMAIL}"
  git status
  git commit -m "[skip ci] update peepdf results"

fi
