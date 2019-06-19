#!/bin/bash
#git clone results output-files

#OUTPUTPATH=$(pwd)/output-files/results
OUTPUTPATH=$(pwd)/results
ORIGSAMPLESPATH=$(pwd)

# Do nothing if folder is empty
 if [[ "$(ls $ORIGSAMPLESPATH/results/shellcode |wc -l)" == 0 ]]; then
	echo "Folder is empty"
else
	for folder in $ORIGSAMPLESPATH/results/shellcode/*/
	  do
	  printf "Working on folder: "${folder}"\n" >> $OUTPUTPATH/sctest_log

	  SAMPLESPATH=${folder%?}
	  #cd /peepdf

	  for file in $SAMPLESPATH/*
	    do
	    xbase=${file##*/}; xfext=${xbase##*.}; xpref=${xbase%.*}
		  echo $(basename $SAMPLESPATH)/$xbase Results: >> $OUTPUTPATH/sctest_log
      docker run -v ${ORIGSAMPLESPATH}:/sctest cincan/peepdf /sctest/${xbase} -f --command="sctest file ${file}" >> $OUTPUTPATH/sctest_log
      #/usr/bin/python peepdf.py $file -f --command="sctest file ${file}" >> $OUTPUTPATH/sctest_log
	  done
	done


	# Update git
	cat $OUTPUTPATH/sctest_log
	cd $ORIGSAMPLESPATH
  #cd $ORIGSAMPLESPATH/output-files
	git add .
#	git config --global user.name "${GITLAB_USER_ID}"
#	git config --global user.email "${GITLAB_USER_EMAIL}"
  git status
  git commit -m "[skip ci] Results update"
fi
