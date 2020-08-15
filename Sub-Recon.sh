#!/bin/bash

mkdir -p ~/Projects/BugBounty/Targets/$1/subdomains/

echo "Running crt.sh..."
curl -s https://crt.sh/?Identity=%.$1 | grep ">*.$1" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<|^[\*]*[\.]*$1" | sort -u | awk 'NF' > ~/Projects/BugBounty/Targets/$1/subdomains/crt.txt
echo "...Complete"

echo "Runnning assetfinder..."
~/go/bin/assetfinder $1 > ~/Projects/BugBounty/Targets/$1/subdomains/assetfinder.txt
echo "...Complete"

echo "Running subfinder..."
~/go/bin/subfinder -d $1 --recursive > ~/Projects/BugBounty/Targets/$1/subdomains/subfinder.txt
echo "...Complete"

echo "Running amass..."
amass enum -active -d $1 > ~/Projects/BugBounty/Targets/$1/subdomains/amass.txt
echo "...Complete"

echo "Compiling..."
cat ~/Projects/BugBounty/Targets/$1/subdomains/* > ~/Projects/BugBounty/Targets/$1/subdomains/subdomains-combined.txt

sort -u  ~/Projects/BugBounty/Targets/$1/subdomains/subdomains-combined.txt >  ~/Projects/BugBounty/Targets/$1/subdomains/subdomains-sorted.txt

echo "All subdomains, saved as  ~/Projects/BugBounty/Targets/$1/subdomains.txt"
grep $1 ~/Projects/BugBounty/Targets/$1/subdomains/subdomains-sorted.txt | tee  ~/Projects/BugBounty/Targets/$1/subdomains.txt


echo "Running HTTProbe to find live hosts, saved as  ~/Projects/BugBounty/Targets/$1/httprobe.txt"
cat  ~/Projects/BugBounty/Targets/$1/subdomains.txt | ~/go/bin/httprobe | tee  ~/Projects/BugBounty/Targets/$1/httprobe.txt

echo "Grabbing images of each live page with aquatone"
cat  ~/Projects/BugBounty/Targets/$1/httprobe.txt | /Users/jh/Projects/BugBounty/1.Recon/aquatone_macos_amd64_1/aquatone 

echo "FIN"
