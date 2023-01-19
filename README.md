# fastq files setup

## Description
Reads fastq recursively from a project directory.  
Finds,  changes filename parts according to a csv file, and copies files.  
Detects duplicates e.g. resequenced and copies to a separate directory.  
This script does not take arguments nor editing but instead works by presetting symlinks outside the script.
Does not currently differentiate between which fastq files are considered resequenced or better when detecting a duplicate.  

## Operation
The rename.csv should have the first column with old names and second column with new names (nameparts to be substituted).  
Move the csv template for renaming to folder ./inFiles  
Create a rename.csv symlink to this template in same folder.  
Create symlink to (external) location of fastq files in ./inFiles called fastq/  
This external directory should be organized by subdirectories originalfastq/ and renamedfastq/  
The renamedfastq/ should have a subdirectory called duplicates/  
