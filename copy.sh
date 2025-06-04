#!/usr/bin/env sh

if [ -z "$1" ]; then
    echo "No argument supplied. Please provide a folder name."
    exit 1
fi

src_dir="/var/lib/repos/gentoo/$1"
if [ ! -d "$src_dir" ]; then
    echo "Source directory '$src_dir' does not exist."
    exit 1
fi

dest_dir="./$1"

mkdir -p $dest_dir
cp -r $src_dir/* $dest_dir

find "$dest_dir" -name 'Manifest' -delete
find "$dest_dir" -name 'metadata.xml' -delete

