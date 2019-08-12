#! /bin/bash
#group report is outdated!
#group report is optimised for mriqc 0.12.1
cd /opt/bids/mriqc_12
mkdir -p reports/$1
find derivatives -iname sub-$1* -exec cp --parents {} reports/$1/ \;

docker run --rm --user $(id -u):$(id -g) --network none -v /opt/bids/mriqc_12/reports/$1:/data:ro -v /opt/bids/mriqc_12/reports/$1:/out poldracklab/mriqc:0.12.1 /data /out group
rm -rf reports/$1/derivatives
ln -frs  reports/sub-$1* reports/$1/reports/
