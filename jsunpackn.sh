#!/bin/bash

which ssh-agent || (apk add --update openssh-client)
eval $(ssh-agent -s)
mkdir -p ~/.ssh
echo "$SSH_PRIV_KEY" | ssh-add -
echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
git config --global user.email "$GITLAB_USER_EMAIL"
git config --global user.name  "$GITLAB_USER_ID"
#git remote set-url --push origin git@gitlab.com:${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}.git

#git clone results output-files
SAMPLESPATH=$(pwd)

if [[ "$(ls $SAMPLESPATH/pdf-source/pdf |wc -l)" == 0 ]]; then  
	echo "Folder is empty"
else
  mkdir -p $SAMPLESPATH/output-files/results
  cd $SAMPLESPATH/output-files
  git init
  git remote add origin git@gitlab.com:${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}.git
  #git remote set-url --push origin git@gitlab.com:${CI_PROJECT_NAMESPACE}/${CI_PROJECT_NAME}.git
  git pull origin master
  cd /jsunpack-n
	for file in $SAMPLESPATH/pdf-source/pdf/*
	  do
	  echo "Processing $file ..."
	  xbase=${file##*/};xfext=${xbase##*.};xpref=${xbase%.*}
	  echo ${xpref}.${xfext}
	  /usr/bin/python jsunpackn.py $file -d $SAMPLESPATH/output-files/shellcode/${xpref}.${xfext}/
	  echo "output folder: $SAMPLESPATH/output-files/shellcode/${xpref}.${xfext}/"
	done

	cd $SAMPLESPATH/output-files
	git add .
	git commit -m "[skip ci] update jsunpack-n results"
  git push -u origin master
fi

