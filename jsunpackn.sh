#!/bin/bash
#git clone results output-files
SAMPLESPATH=$(pwd)
set -xeu
cd /jsunpack-n

#if [[ "$(ls $SAMPLESPATH/pdf-source/pdf |wc -l)" == 0 ]]; then  
if [[ "$(ls $SAMPLESPATH/pdf |wc -l)" == 0 ]]; then  
	echo "Folder is empty"
else
	#for file in $SAMPLESPATH/pdf-source/pdf/*
  ls $SAMPLESPATH/pdf
	for file in $SAMPLESPATH/pdf/*
	  do
	  echo "Processing $file ..."
	  xbase=${file##*/};xfext=${xbase##*.};xpref=${xbase%.*}
	  #/usr/bin/python jsunpackn.py $file -d $SAMPLESPATH/output-files/shellcode/${xpref}.${xfext}/
    cd $SAMPLESPATH/pdf
    #export temp_path_file=`python3 -c 'import os; filepath=os.path.join(os.getcwd(),os.listdir()[0]); print(filepath)'`
    #export temp_file=`python3 -c 'import os; filepath=os.listdir(os.getcwd())[0]; print(filepath)'`    
    
    docker run cincan/jsunpack-n ${file} -d $SAMPLESPATH/shellcode/${xpref}.${xfext}/
    #docker run cincan/jsunpack-n "${xbase}" -d $SAMPLESPATH/shellcode/${xpref}.${xfext}/
    #/usr/bin/python jsunpackn.py $file -d $SAMPLESPATH/shellcode/${xpref}.${xfext}/
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
