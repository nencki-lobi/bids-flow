#! /bin/bash
cd /opt/bids/mriqc
mkdir -p reports/$1
find derivatives -iname sub-$1* -exec cp --parents {} reports/$1/ \;

docker run --rm --user $(id -u):$(id -g) --network none -v /opt/bids/mriqc/reports/$1:/data:ro -v /opt/bids/mriqc/reports/$1:/out poldracklab/mriqc:0.12.1 /data /out group
rm -rf reports/$1/derivatives
ln -rs  reports/sub-$1* reports/$1/reports/
