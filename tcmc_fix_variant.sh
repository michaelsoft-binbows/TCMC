#!/bin/bash

# == FIX VARIANT ==
# Some files are not contained ....

set -e

echo "== FIX VARIANT =="
echo "1st argument: Specify the folder of the SPL repo (e.g., \"busybox\")"
echo "2nd argument: File name for code_variability.spl.csv from \"Extraction\""
echo "3rd argument: Specify the folder generated in ."
echo ""

# Parameters are incorrect
if [ $# -ne 3 ]; then
    echo -e "\e[31mWrong arguments.\e[0m"
    echo -e "The program has been terminated."
    exit 1
fi

if [[ ! -d $1 ]]; then
    echo -e "\e[31mThe folder does not exist: $1.\e[0m"
    echo -e "The program has been terminated."
    exit 1
fi

if [[ ! -f $2 ]]; then
    echo -e "\e[31mThe file does not exist: $2.\e[0m"
    echo -e "The program has been terminated."
    exit 1
fi

if [[ ! -d $3 ]]; then
    echo -e "\e[31mThe folder does not exist: $2.\e[0m"
    echo -e "The program has been terminated."
    exit 1
fi

echo "Start comparison ..."
echo ""

splRepo="$1"
csv="$2"
mcaoRepo="$3/TypeChef-BusyboxAnalysis/"

FILES=$(find $splRepo -type f)
FILES_CSV=$(cat $csv | cut -d";" -f1 | uniq)

# 1: Copy files
for f in $FILES_CSV; do
    FILES_tmp=$(echo "$FILES" | grep -v "$f")
    FILES=$FILES_tmp
done

echo "$FILES" > FILES.tmp

for f in $FILES; do
    f_dest="${mcaoRepo}custom_$f"
    #echo $f_dest
    mkdir -p "${f_dest%/*}"
    #echo "mach ${f_dest%/*}"
    #echo "kopier $f in $f_dest"
    sudo cp $f $f_dest
done

# 2. Schritt

for f in $FILES_CSV; do
    f_dest="${mcaoRepo}custom_busybox/$f"
    echo $f_dest >> touch_files
    mkdir -p "${f_dest%/*}"
    touch $f_dest
    
done

echo -e "\e[32mWhen this message is displayed to you, you have successfully run this program.\e[0m"
