#!/bin/bash
cd /opt/dicom_dump
#for i in *; do
for d in `find /opt/dicom_dump -mindepth 1 -maxdepth 1 -type d`; do
i=${d##*/}

orig=/opt/dicom_dump/$i
dest=/opt/bids/dicoms/$i
subjid=${i//_/} #removes underscores

if [ ! -f $orig/busy ] ; then
if [ ! -f $dest/busy ] ; then

cp -r $orig $dest
rm -r $orig
touch $dest/busy

docker run --rm --network none -v /opt/bids/dicoms:/data:ro -v /home/mibackup/bids/heuristic.py:/heuristic.py -v /opt/bids:/output nipy/heudiconv:latest -d /data/{subject}/*/*/*.dcm -s $i -f /heuristic.py -b --overwrite -o /output
docker run --rm --network none -v /opt/bids:/data:ro -v /opt/bids/mriqc:/out poldracklab/mriqc:0.12.1 /data /out participant --participant-label $subjid
docker run --rm --network none -v /opt/bids:/data:ro -v /opt/bids/mriqc:/out poldracklab/mriqc:0.12.1 /data /out group

cp -r $dest /opt/.trash/
rm -r $dest

break #one subject at time and exits
fi
fi
done
