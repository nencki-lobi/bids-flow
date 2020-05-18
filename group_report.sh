#! /bin/bash
#group report for ver. 15
cd /srv/mriqc
mkdir -p reports/$1
find reports -maxdepth 1 -iname "sub-$1*" -exec cp -r --parents {} reports/$1/ \;

docker run --rm --user $(id -u):$(id -g) --network none -v /srv/mriqc:/data:ro -v /srv/mriqc/reports/$1/reports:/out poldracklab/mriqc:0.15.0 /data /out group
rm -rf reports/$1/sub-$1*
sleep 3
ln -frs  reports/sub-$1* reports/$1/reports/
