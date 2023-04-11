#!/bin/bash

file_name=$1

sed -i "/\GET\b/d" $file_name
sed -i 's/\[/"\[/; s/\]/\]"/ ; s/"/\n/g ; s/ /\n/g' $file_name
sed -i '/^$/d' $file_name
awk -i inplace 'NR==7 || NR==11 || (NR>7 && (NR-7)%12==0) || (NR>11 && (NR-11)%12 ==0)' $file_name
