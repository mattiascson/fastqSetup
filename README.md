# fastq files setup

## Description
Reads fastq recursively from a project directory.  
Finds,  changes filename parts according to a csv file, and copies files.  
Duplicates e.g. resequenced are copied to a separate directory by supplying directory prefix 
This script does not take arguments but some editing and by presetting symlinks outside the script.

## Operation
The rename.csv should have the first column with old names and second column with new names (nameparts to be substituted).  
Move the csv template for renaming to folder ./inFiles  
Find some string in the directory name of resequenced files and edit to script.
Create a rename.csv symlink to this template in same folder.  
Create symlink to (external) location of fastq files in ./inFiles called fastq/  
This external directory should be organized by subdirectories originalfastq/ and renamedfastq/  
The renamedfastq/ should have a subdirectory called resequenced/  
If script fails it can restart and determine what should be copied.  