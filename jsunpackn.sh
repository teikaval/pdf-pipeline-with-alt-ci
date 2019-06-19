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
	  #/usr/bin/python jsunpackn.py $file -d $SAMPLESPATH/output-files/shellcode/${xpref}.${xfext}/
    cd $SAMPLESPATH/pdf
    #docker run -v ${SAMPLESPATH}:/jsunpack-n/ cincan/jsunpack-n /jsunpack-n/${xbase} 
    /usr/bin/python jsunpackn.py $file -d $SAMPLESPATH/shellcode/${xpref}.${xfext}/
	  #echo "output folder: $SAMPLESPATH/output-files/shellcode/${xpref}.${xfext}/"
	  echo "output folder: $SAMPLESPATH/shellcode/${xpref}.${xfext}/"
	done

	#cd $SAMPLESPATH/output-files
	cd $SAMPLESPATH
  git add .
#	git config --global user.name "${GITLAB_USER_ID}"
#	git config --global user.email "${GITLAB_USER_EMAIL}"
  git status
  git commit -m "[skip ci] update jsunpack-n results"
fi
