#!/bin/bash

# Ground truth data extraction

# uncomment to clear all docker images
#docker system prune -a

# uncomment to remove git repository
#rm -r VEVOS_Extraction/

git clone https://github.com/VariantSync/VEVOS_Extraction.git

cd VEVOS_Extraction/

# use branch with fixes
git checkout next-release

# has to be executed only once
./build-docker-image.sh

echo "Enter commit: "
read commit

# the actual ground truth data extraction
./start-extraction.sh busybox $commit
