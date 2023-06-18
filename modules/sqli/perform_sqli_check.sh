#!/bin/sh

model_file_path="modules/resources/sqli_model.h5"
vocabulary_file_path="modules/resources/sqli_vocabulary.pkl"
file_path=$1
address=$(basename $file_path)

python3 modules/sqli/sqli_check.py $address $model_file_path $vocabulary_file_path
