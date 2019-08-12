#!/bin/bash

#for i in *; do
for d in `find /srv/dicom_dump -mindepth 1 -maxdepth 1 -type d`; do
i=${d##*/}
orig=/srv/dicom_dump/$i

if [[ "$i" = fantom_birn* ]]; then
machine=~/bids-flow/phantom_fmriqa.sh
dest=/srv/fmriqa/dicoms/$i
echo FANTOM
else
machine=~/bids-flow/bids_apps.sh
dest=/srv/mriqc/dicoms/$i
fi

if [ ! -f $orig/busy ] ; then
if [ ! -f $dest/busy ] ; then

cp -r $orig $dest
rm -rf $orig
touch $dest/busy

. $machine $i

cp -r $dest /srv/.trash/
rm -rf $dest

break #one subject at time and exits
fi
fi
done
