#!/bin/bash
SAMPLESPATH=$(pwd)
#ls $SAMPLESPATH/pdf-source/ -R
ls $SAMPLESPATH -R

# Do nothing if folder is empty
#number_of_files=$(ls $SAMPLESPATH/pdf-source/pdf |wc -l)
number_of_files=$(ls $SAMPLESPATH/pdf | wc -l)
if [ "$number_of_files" == 0 ]; then
	echo "Folder is empty"
else
	# Scan the files
	echo "Processing files"
	#cd /pdfid
	ls -R
	for file in $SAMPLESPATH/pdf/*
  #for file in $SAMPLESPATH/pdf-source/pdf/*
		do
	  xbase=${file##*/}; xfext=${xbase##*.}; xpref=${xbase%.*}
	  echo Analysing: ${file##*/}
	  hash=$(md5sum "${file}" | cut -d ' ' -f1)
	        #/usr/bin/python pdfid.py $file -p plugin_triage pdf-source/pdf/*.* > result
	  #/usr/bin/python pdfid.py $file -p plugin_triage pdf/*.* > result
		docker run cincan/pdfid $file -p plugin_triage pdf/*.* > result
    if (cat result | tee -a $SAMPLESPATH/pdfid.log | grep -c 1.00);then
	    echo $hash --- ${file##*/} >> $SAMPLESPATH/pdfid-malicious.log
	    echo "Likely malicious"
	  elif (cat result | grep -c 0.00);then
	    echo $hash --- ${file##*/} >> $SAMPLESPATH/pdfid-clean.log
	    echo "Likely clean"
	  else
	    echo $hash --- ${file##*/} >> $SAMPLESPATH/pdfid-requires-more-analysis.log
	    echo "Needs further analysis"
	  fi
	  echo $file_number / $number_of_files;let "file_number=file_number+1"
	  echo --------------------------
	done

	# Update the results-git
	cd $SAMPLESPATH
	ls $SAMPLESPATH -R
	#git clone results output-files

	printf "\n------------------------\n\n"
	echo "Results:" | tee -a $SAMPLESPATH/pdfid.log
	echo "Malicious: "$(wc -l $SAMPLESPATH/pdfid-malicious.log| cut -d ' ' -f1) | tee -a $SAMPLESPATH/pdfid.log
        echo "Clean: "$(wc -l $SAMPLESPATH/pdfid-clean.log| cut -d ' ' -f1) | tee -a $SAMPLESPATH/pdfid.log
        echo "Requires further analysis: "$(wc -l $SAMPLESPATH/pdfid-requires-more-analysis.log| cut -d ' ' -f1) | tee -a $SAMPLESPATH/pdfid.log
	echo "number of samples: $number_of_files" | tee -a $SAMPLESPATH/pdfid.log

	#cp $SAMPLESPATH/*.log $SAMPLESPATH/output-files/results/
	mv $SAMPLESPATH/*.log $SAMPLESPATH/results/
  git add .
#	git config --global user.name "${GITLAB_USER_ID}"
#	git config --global user.email "${GITLAB_USER_EMAIL}"
	git status
  git commit -m "[skip ci] update pdfid results"
fi
