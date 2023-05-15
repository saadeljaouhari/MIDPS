#!/bin/sh

for file in *.html ; do
    new_name=${file%.html}.txt
    mv $file $new_name
done
