#!/bin/bash
sites=$(cat sites.list)
today=$(date +%s)
rm -f /tmp/cert

function validate {
llday=$(date --date="$1" +%s)
daydiff=$(($llday - $today))
if [ $daydiff -gt 0 ] 
then 
	isvalid="YES" 
fi
if [ $daydiff -lt 0 ] 
then 
	isvalid="NO"
fi
}
for site in $sites
do

echo | openssl s_client -servername "$site" -connect "$site":443 2>&1 | sed --quiet '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'>/tmp/cert
#echo | openssl s_client -connect $site:443 2>&1 | sed --quiet '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'>/tmp/$site.pem
#lastday=$(echo | openssl s_client -connect $site:443 2>/dev/null | openssl x509 -noout -dates | grep notAfter| cut -d '=' -f 2)

lastday=$(openssl x509 -noout -enddate -in /tmp/cert 2>/dev/null | cut -d '=' -f 2)

validate "$lastday"
lastdayout=$(date --date="$lastday" +%d.%m.%Y)
if [ $isvalid == "NO" ] 
then
	printf "%-30s %-25s %s \n" "$site" "$isvalid" "--.--.--"
else
	printf "%-30s %-25s %s \n" "$site" "$isvalid" "$lastdayout"
fi

rm /tmp/cert
done
