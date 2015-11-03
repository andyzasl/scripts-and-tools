#!/bin/bash

rootdir="/media/99ae1b9d-cad3-4d44-bc86-17aa1a91597a/BaculaBackups"

#find purged volumes
PURGED=$(echo list media | bconsole  | grep Purged | cut -d '|' -f 3 | sed 's/ //g')
echo "============= Bacula reporting: PURGED volumes ========================="
echo "$PURGED"

echo "============== Going to DELETE data from Catalog =============="
for vol in $PURGED
do
        echo "Going to delete data from Catalog for $vol"
        echo "delete volume=$vol yes" | bconsole

done
echo "============= Data from Catalog Cleared. ======================"


#find purged volumes file paths
FILES=$(echo $PURGED | xargs -n 1  find $rootdir -name)
echo "$FILES"
rm -v $FILES
