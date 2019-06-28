#!/bin/bash
#git clone results output-files
git config --global user.email "${DRONE_COMMIT_AUTHOR_EMAIL}"
eval $(ssh-agent -s)
mkdir -p ~/.ssh
echo "$GIT_SSH_KEY" | ssh-add -
echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config

OUTPUTPATH=$(pwd)/results
#OUTPUTPATH=$(pwd)/output-files/results
ORIGSAMPLESPATH=$(pwd)

# Do nothing if folder is empty
if [[ "$(ls $ORIGSAMPLESPATH/results/shellcode |wc -l)" == 0 ]]; then
	echo "Folder is empty"
else
	for folder in $ORIGSAMPLESPATH/results/shellcode/*/
	  do
	    printf "Working on folder: "${folder}"\n" >> $OUTPUTPATH/sctest_log

	    SAMPLESPATH=${folder%?}
	    cd /peepdf

	    for file in $SAMPLESPATH/*
	        do
	        xbase=${file##*/}; xfext=${xbase##*.}; xpref=${xbase%.*}

		echo $(basename $SAMPLESPATH)/$xbase Results: >> $OUTPUTPATH/sctest_log
		/usr/bin/python peepdf.py $file -f --command="sctest file ${file}" >> $OUTPUTPATH/sctest_log
	  done
	done


	# Update git
	cat $OUTPUTPATH/sctest_log
	cd $ORIGSAMPLESPATH/
	git add .
  git config --global user.name "${DRONE_COMMIT_AUTHOR_NAME}"
#	git config --global user.email "${DRONE_COMMIT_AUTHOR_EMAIL}"
	git commit -m "[ci skip] Results update"
  git config --global push.default matching
  git push
fi
