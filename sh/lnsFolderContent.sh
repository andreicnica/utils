#!/bin/sh

# Shell script makes symlinks for the folders content to a target directory
# Author: Marcel Gotsch <gts@octans.uberspace.de>

# Exit on error
set -e

usage="Usage $0 <source-folder> <target-folder>"

# Check args
if [ -z "$1" ] || [ -z "$2" ]; then
	echo ${usage}
	exit 1
fi

sourced=${1%/}
targetd=${2%/}

# Info output
echo "Symlinking..."
echo "SOURCE: ${sourced}"
echo "TARGET: ${targetd}"

files=${sourced}/*

for file in ${files}; do
	echo "${file} --> ${targetd}/$(basename ${file})"
	ln -fs ${file} ${targetd}/$(basename ${file})
done
