# fastq files setup

## Description

Reads fastq recursively from a project directory.\
Finds, copies and changes parts of filenames according to a csv file.\
Resequenced data fastq files are copied to a separate directory by supplying directory prefix This script does not take arguments, but some require some editing presetting symlinks outside the script.

## Operation

The rename.csv should have the first column with old names and second column with new names (nameparts to be substituted during copying).\
Move the csv template for renaming to folder ./inFiles\
Create a rename.csv symlink to this template in same folder. Find some substring in the directory name of the resequenced astq files and edit to script to differentiate these files. Create symlink to (external) location of fastq files in ./inFiles called fastq/\
This external directory should be organized by subdirectories originalfastq/ and renamedfastq/\
The renamedfastq/ should have a subdirectory called resequenced/\
If script fails it can restart and determine what needs to be copied.
