#!/bin/sh

. ./config.conf

suspect_traffic_file_path=$1

python3 modules/sqli/sqli_check.py $suspect_traffic_file_path $model_file_path
