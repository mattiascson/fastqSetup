# fastq files setup

## Description
Reads fastq recursively from a project directory.  
Finds,  changes filenames according to a csv file, and copies files.  
Detects duplicates e.g. resequenced and copies to separate directory.  
This script does not take arguments nor editing but instead works by presetting symlinks.
Does not currently differentiate between which fastq files are considered re sequenced or better when detecting a duplicate.  

## Operation
The csv should have the first column with old names and second column with new names.  
Move the csv template for renaming to folder ./inFiles  
Create a symlink to this template in same folder names rename.csv  
Create symlink to (external) location of fastq files in ./inFiles called fastq/  
This external directory should be organized by subdirectories originalfastq/ and renamedfastq/  
The renamedfastq/ should have a subdirectory called duplicates/  
