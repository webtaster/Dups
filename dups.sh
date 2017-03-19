#!/bin/bash

#
# Quick script to list duplicate files under the current directory
# v 1.2
#

echo Running find... >&2
find . -type f -size +0 -printf "%-25s %p\n" | sort -n | uniq -D -w 25  > /tmp/dupsizes.$$


echo Calculating $(wc -l < /tmp/dupsizes.$$) check sums... >&2
cat /tmp/dupsizes.$$ |
   sed 's/^\w* *\(.*\)/md5sum "\1"/' | 
      sh | 
         sort | 
            uniq -w32 --all-repeated=separate  > /tmp/dups.$$


echo Found $(grep -c . /tmp/dups.$$) duplicated files
while read md5 filename
do
   if [[ ! -z "$filename" ]]; then
      ls -l "$filename"
   else
      echo
   fi
done < /tmp/dups.$$
   



