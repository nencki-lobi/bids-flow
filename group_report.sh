#! /bin/bash
cd /opt/bids/mriqc
mkdir reports/$1
find derivatives -iname sub-$1* -exec cp --parents {} reports/$1/ \;
#mkdir reports/$1/reports

docker run --rm --network none -v /opt/bids/mriqc/reports/$1:/data:ro -v /opt/bids/mriqc/reports/$1:/out poldracklab/mriqc:0.12.1 /data /out group
rm -rf reports/$1 #reports/bold.html and index.html are write protected
