#!/bin/bash

#for i in *; do
for d in `find /opt/dicom_dump -mindepth 1 -maxdepth 1 -type d`; do
i=${d##*/}
orig=/opt/dicom_dump/$i

if [[ "$i" = fantom_birn* ]]; then
machine=~/bids/phantom_fmriqa.sh
dest=/opt/phantom/dicoms/$i
else
machine=~/bids/bids_apps.sh
dest=/opt/bids/dicoms/$i
fi

if [ ! -f $orig/busy ] ; then
if [ ! -f $dest/busy ] ; then

cp -r $orig $dest
rm -rf $orig
touch $dest/busy

. $machine $i

cp -r $dest /opt/.trash/
rm -rf $dest

break #one subject at time and exits
fi
fi
done
