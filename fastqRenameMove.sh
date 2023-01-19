#!/usr/bin/bash

# Finds all fastq files to process.
ls -R inFiles/fastq/originalfastq/ | grep "fastq.gz" > ./outFiles/fastqFiles.txt
# Creates or restet file for list of copied files
cat /dev/null > ./outFiles/copiedFiles.log

for File in $(cat ./outFiles/fastqFiles.txt)
do
  echo $File
  # Prune ending of filename to match strings in rename.csv
  pruneFile=$(echo $File | cut -d "_" -f 1)
  echo $pruneFile
  # Check if the pruned fileneme is targeted for rename by targeting first column
  if awk -F, '{ print $1 }' ./inFiles/rename.csv | grep -Fxq "$pruneFile"
    then
      # Create new filename
      echo "Create new filename"
        # Find linenumber which match
        lineNumber=$(grep -n $pruneFile ./inFiles/rename.csv | cut -d":" -f1)
        # Find new name part using linenumber
        newNamePart=$(awk -F, -v i=$lineNumber 'FNR == i {print $2}' ./inFiles/rename.csv)
        # Construct new filename
        newFilename=$(echo $File | sed s/$pruneFile/$newNamePart/)
        echo $newFilename
      # Copy file with rename
      # Has file already been copied?
      if grep -Fxq "$File" ./outFiles/copiedFiles.log
        then
          # Copy to renamedfastq/duplicates
          echo "Copy to duplicates"
          find -L . -name $File -exec cp {} ./inFiles/fastq/renamedfastq/duplicates/$newFilename \;
        else
          # Copy to renamedfastq
          echo "Copy renamedfastq"
          find -L . -name $File -exec cp {} ./inFiles/fastq/renamedfastq/$newFilename \;
          echo $File >> ./outFiles/copiedFiles.log
        fi
    else
      # Just copy file. No rename
      echo "Keep filename"
      # Has file already been copied?
      if grep -Fxq "$File" ./outFiles/copiedFiles.log
        then
          # Copy to renamedfastq/duplicates
          echo "Copy to duplicates"
          find -L . -name $File -exec cp {} ./inFiles/fastq/renamedfastq/duplicates \;
        else
          # Copy to renamedfastq
          echo "Copy renamedfastq"
          find -L . -name $File -exec cp {} ./inFiles/fastq/renamedfastq/ \;
          echo $File >> ./outFiles/copiedFiles.log
        fi
    fi
  echo "Next"
done