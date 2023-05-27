#!/bin/sh

while IFS= read -r link; do
  wget --spider -r -p -nd $link
done < web_pages
