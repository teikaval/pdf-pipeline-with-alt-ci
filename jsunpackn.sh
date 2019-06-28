#!/bin/bash
#git clone results output-files
SAMPLESPATH=$(pwd)
cd /jsunpack-n

#if [[ "$(ls $SAMPLESPATH/pdf-source/pdf |wc -l)" == 0 ]]; then  
if [[ "$(ls $SAMPLESPATH/pdf |wc -l)" == 0 ]]; then  
	echo "Folder is empty"
else
	#for file in $SAMPLESPATH/pdf-source/pdf/*
	for file in $SAMPLESPATH/pdf/*
	  do
	  echo "Processing $file ..."
	  xbase=${file##*/};xfext=${xbase##*.};xpref=${xbase%.*}
	  echo ${xpref}.${xfext}
	  #/usr/bin/python jsunpackn.py $file -d $SAMPLESPATH/output-files/shellcode/${xpref}.${xfext}/
	  /usr/bin/python jsunpackn.py $file -d $SAMPLESPATH/results/shellcode/${xpref}.${xfext}/
	  echo "output folder: $SAMPLESPATH/output-files/shellcode/${xpref}.${xfext}/"
	done

	#cd $SAMPLESPATH/output-files
  cd $SAMPLESPATH
  ls $SAMPLESPATH -R
	git add .
	git config --global user.name "${DRONE_COMMIT_AUTHOR_NAME}"
	git config --global user.email "${DRONE_COMMIT_AUTHOR_EMAIL}"
	git commit -m "[ci skip] update jsunpack-n results"
fi
