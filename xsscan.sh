#!/bin/bash

mkdir  ~/Projects/BugBounty/xss/$1
python3 ~/Projects/BugBounty/1.Recon/ParamSpider/paramspider.py --domain $1 --exclude svg,jpg,css,js | tee  ~/Projects/BugBounty/xss/$1/params.txt
~/go/bin/gf xss  ~/Projects/BugBounty/xss/$1/params.txt | tee  ~/Projects/BugBounty/xss/$1/xss.txt
grep -Eo '(http|https)://[^"]+'  ~/Projects/BugBounty/xss/$1/xss.txt >  ~/Projects//BugBounty/xss/$1/xssurl.txt
while read u
do
echo "\n\n"
echo $u ----------------
python3  ~/Projects/BugBounty/2.Exploits/XSS/XSStrike/xsstrike.py -u $u
done <  ~/Projects/BugBounty/xss/$1/xssurl.txt | tee  ~/Projects/BugBounty/xss/$1/strike.txt
