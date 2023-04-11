#!/bin/sh

echo $1 | awk '{printf("%s %s",$7,$11)}'
