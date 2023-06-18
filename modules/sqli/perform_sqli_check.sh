#!/bin/sh

suspect_traffic_file_path=$1
model_file_path="modules/resources/sqli_model.h5"
vocabulary_file_path="modules/resources/sqli_vocabulary.pkl"

python3 modules/sqli/sqli_check.py $suspect_traffic_file_path $model_file_path $vocabulary_file_path
