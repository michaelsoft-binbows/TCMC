#!/bin/bash

# == FIX VARIANT ==
# Some files are not contained ....

set -e

echo "== FIX VARIANT =="
echo "Save the busybox git repository in this folder as \"busybox\"."
echo "1st argument: Specify relative path to code_variability.spl.csv (from \"Extraction\" output)"
echo "2nd argument: Specify the project folder."
echo ""

# Parameters are incorrect
if [ $# -ne 2 ]; then
    echo -e "\e[31mWrong arguments.\e[0m"
    echo -e "The program has been terminated."
    exit 1
fi

if [[ ! -f $1 ]]; then
    echo -e "\e[31mThe file does not exist: $1.\e[0m"
    echo -e "The program has been terminated."
    exit 1
fi

if [[ ! -d $2 ]]; then
    echo -e "\e[31mThe folder does not exist: $1.\e[0m"
    echo -e "The program has been terminated."
    exit 1
fi

echo "Start fix  ..."
echo ""

splRepo="busybox"
csv="$1"
mcaoRepo="$2/TypeChef-BusyboxAnalysis/"

FILES=$(find $splRepo -type f)
FILES_CSV=$(cat $csv | cut -d";" -f1 | uniq | tail -n +2)

# debug
#echo "$FILES" > FILES.tmp
#echo "$FILES_CSV" > FILES_CSV.tmp

COPY_FILES=$FILES

# Filter files to be copied
for f in $FILES_CSV; do
    COPY_FILES=$(echo "$COPY_FILES" | grep -v "^busybox/$f\$") # delete file, that is contained in csv, from list
done

# debug
#echo "$COPY_FILES" > COPY_FILES.tmp # all files that are not in csv -> presence condition always true

# copy files
for f in $FILES; do
    f_dest="${mcaoRepo}custom_$f"
    mkdir -p "${f_dest%/*}"
    sudo cp $f $f_dest
done


echo -e "\e[32mWhen this message is displayed to you, you have successfully run this program.\e[0m"
exit 0

#debug
#echo "" > touched_files.tmp

# necessary?
# touch all files whose presence condition is false but the KBuildMiner requires their presence
for f in $FILES_CSV; do
    f_dest="${mcaoRepo}custom_busybox/$f"
    mkdir -p "${f_dest%/*}"
    if [[ ! -f $f_dest ]]; then
        echo $f_dest >> touched_files.tmp
        touch $f_dest
    fi
done
