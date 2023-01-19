#!/usr/bin/bash

# Finds all fastq files to process. Exclude string from resequenced files
ls -R -I200110* inFiles/fastq/originalfastq/ | grep "fastq.gz" > ./outFiles/fastqFiles.txt
# Finds all resequenced fastq
ls -R -I200110* inFiles/fastq/originalfastq/200110_M00485_0547_000000000-CW4WC/ | grep "fastq.gz" > ./outFiles/fastqReseqFiles.txt

# Remove the last copied file (2) to secure against if failure during copying
sampleToRemove=$(tail -n1 ./outFiles/copiedFiles.log | cut -d "_" -f1 | cut -d "-" -f3-6 | cut -b 7-)
sed -i /$sampleToRemove/d ./outFiles/copiedFiles.log

sampleToRemove=$(tail -n1 ./outFiles/copiedReseqFiles.log | cut -d "_" -f1 | cut -d "-" -f3-6 | cut -b 7-)
sed -i /$sampleToRemove/d ./outFiles/copiedReseqFiles.log

# Creates or reset file for list of copied files.
cat /dev/null > ./outFiles/copiedFiles.log
cat /dev/null > ./outFiles/copiedReseqFiles.log

# Recreates copiedFiles.log if restart due to failure. Put only R1 in list but check for both strand fastq laterlater
alreadyCopied=$(ls -Ireseq* -I*_R1_* ./inFiles/fastq/renamedfastq/)
for copied in $alreadyCopied
do
  sampleNO=$(echo $copied | cut -d "-"  -f 1)
  #Check if both pair end fastq were copied
  NOCopies=$(ls ./inFiles/fastq/renamedfastq/$sampleNO* | grep /"$sampleNO[-][Wmc]" | wc -l)
  if [ $NOCopies -eq 2 ]
  then
    cat ./outFiles/fastqFiles.txt | grep Sample"$sampleNO"- >> ./outFiles/copiedFiles.log
  fi
done

# Recreates copiedReseqFiles.log if restart due to failure. Put only R1 in list but check for both strand fastq laterlater
alreadyCopied=$(ls -I*_R1_* ./inFiles/fastq/renamedfastq/resequenced/)
for copied in $alreadyCopied
do
  sampleNO=$(echo $copied | cut -d "-"  -f 1)
  #Check if both pair end fastq were copied
  NOCopies=$(ls ./inFiles/fastq/renamedfastq/resequenced/$sampleNO* | grep /"$sampleNO[-][Wmc]" | wc -l)
  if [ $NOCopies -eq 2 ]
  then
    cat ./outFiles/fastqReseqFiles.txt | grep Sample"$sampleNO"- >> ./outFiles/copiedReseqFiles.log
  fi
done

# Copy and rename files not in resequenced list
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
          # Don't copy
          echo "Already copied"
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
          # Don't copy
          echo "Already copied"
        else
          # Copy to renamedfastq
          echo "Copy renamedfastq"
          find -L . -name $File -exec cp {} ./inFiles/fastq/renamedfastq/ \;
          echo $File >> ./outFiles/copiedFiles.log
        fi
    fi
  echo "Next"
done

# Copy and rename files resequenced
for File in $(cat ./outFiles/fastqReseqFiles.txt)
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
      if grep -Fxq "$File" ./outFiles/copiedReseqFiles.log
        then
          # Don't copy
          echo "Already copied"
        else
          # Copy to renamedfastq
          echo "Copy renamedfastq"
          find -L . -name $File -exec cp {} ./inFiles/fastq/renamedfastq/resequenced/$newFilename \;
          echo $File >> ./outFiles/copiedReseqFiles.log
        fi
    else
      # Just copy file. No rename
      echo "Keep filename"
      # Has file already been copied?
      if grep -Fxq "$File" ./outFiles/copiedReseqFiles.log
        then
          # Don't copy
          echo "Already copied"
        else
          # Copy to renamedfastq
          echo "Copy renamedfastq/resequenced"
          find -L . -name $File -exec cp {} ./inFiles/fastq/renamedfastq/resequenced/ \;
          echo $File >> ./outFiles/copiedReseqFiles.log
        fi
    fi
  echo "Next"
done

