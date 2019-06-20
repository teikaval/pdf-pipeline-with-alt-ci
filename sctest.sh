#!/bin/bash
#git clone results output-files

which ssh-agent || (apk add --update openssh-client)
eval $(ssh-agent -s)
mkdir -p ~/.ssh
echo "$SSH_PRIV_KEY" | ssh-add -
echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
git config --global user.email "$GITLAB_USER_EMAIL"
git config --global user.name  "$GITLAB_USER_ID"

ORIGSAMPLESPATH=$(pwd)
mkdir -p $(pwd)/output-files/results/shellcode && cd $SAMPLESPATH/output-files
git init
git remote add origin git@gitlab.com:${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}.git
git pull origin master
OUTPUTPATH=$(pwd)/results

# Do nothing if folder is empty
 #if [[ "$(ls $ORIGSAMPLESPATH/results/shellcode |wc -l)" == 0 ]]; then
 if [[ "$(ls $OUTPUTPATH/shellcode |wc -l)" == 0 ]]; then
	echo "Folder is empty"
else
  for folder in $OUTPUTPATH/shellcode/*
	  do
	    printf "Working on folder: ${folder}\n" >> $OUTPUTPATH/sctest_log

	    SAMPLESPATH=${folder%?}
			echo ${folder%?}
	    cd /peepdf

	    for file in $SAMPLESPATH/*
	        do
	        xbase=${file##*/}; xfext=${xbase##*.}; xpref=${xbase%.*}

		echo $(basename $SAMPLESPATH)/$xbase Results: >> $OUTPUTPATH/sctest_log
		echo $file
		/usr/bin/python peepdf.py $file -f --command="sctest file ${file}" >> $OUTPUTPATH/sctest_log
	  done
	done

	ls $OUTPUTPATH -R

	# Update git
	cat $OUTPUTPATH/sctest_log
	cd $ORIGSAMPLESPATH/output-files
	git add .
	git commit -m "[skip ci] Results update"
  git push -u origin master
fi
