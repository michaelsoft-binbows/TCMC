#!/bin/bash

set -e

echo "Starting TCMC: (1) setup ..."
echo ""

echo "== INSTRUCTION =="
echo "1st argument: A folder name that does not exist where the TCMC is installed in. (Refrain from using forward slashes)"
echo ""

# Parameter passen nicht
if [ $# -ne 1 ]; then
    echo -e "\e[31mFaulty arguments.\e[0m"
    echo -e "TCMC has been exited."
    exit 1
fi
if test -d $1; then
    echo -e "\e[31mFolder does already exist: $1.\e[0m"
    echo -e "TCMC has been exited."
    exit 1
fi

echo "In order to use this tool, the following programs with the following versions have to be installed on the system:"
echo " - Java (JVM) 8"
echo " - Java (JVM) 17"
echo " - Scala 2.11.12"
echo " - sbt script version 1.17.1"
read -p "Are those programs installed? [j/N] " eingabe

if [[ ! "$eingabe" = "j" ]]; then
    echo -e "TCMC has been exited due to missing programs."
    exit 1
fi

echo "Create folder \"$1\"."
mkdir $1
cd $1

echo "Downloading TypeChef ..."
git clone https://github.com/ckaestne/TypeChef &> /dev/null
echo -e "\e[32mDownload successful.\e[0m"

echo "Downloading TypeChef-BusyboxAnalysis ..."
git clone https://github.com/michaelsoft-binbows/TypeChef-BusyboxAnalysis &> /dev/null
echo -e "\e[32mDownload successful.\e[0m"

# NOT NEEDED
#echo "Downloading KBuildMiner ..."
#git clone https://github.com/ckaestne/KBuildMiner &> /dev/null
#echo -e "\e[32mDownload successful.\e[0m"

# NOT NEEDED
# echo "Downloading kconfigreader ..."
# git clone https://github.com/ckaestne/kconfigreader &> /dev/null
# echo -e "\e[32mDownload successful.\e[0m"

cd TypeChef
echo "Choose Java version 8!"
sudo update-alternatives --config java
sbt mkrun

cd ../TypeChef-BusyboxAnalysis

echo "Downloading busybox ..."
git clone https://git.busybox.net/busybox/ ./custom_busybox &> /dev/null
echo -e "\e[32mDownload successful.\e[0m"

echo "Downloading & extracting header files for Busybox ..."
mkdir systems && mkdir systems/redhat
wget http://www.cs.cmu.edu/~ckaestne/tmp/includes-redhat.tar.bz2 -P systems/redhat/ &> /dev/null
tar -xjf systems/redhat/includes-redhat.tar.bz2 -C systems/redhat/
echo -e "\e[32mDownload successful.\e[0m"

#echo "Herunterladen: jar Datei zu KBuildMiner ..."
#wget https://github.com/AlexanderSchultheiss/KbuildMinerExtractor/raw/master/res/net/ssehub/kernel_haven/kbuildminer/res/kbuildminer.jar -P KBuildMiner/ &> /dev/null
#echo -e "\e[32mErfolgreich fertig.\e[0m"

echo -e "\e[32mWhen this message is displayed to you, you have successfully run TCMC setup (1).\e[0m"
echo ""
echo -e "Next step: $1/TypeChef-BusyboxAnalysis/tcmc_start.sh ..."

exit 0
