#!/bin/bash

subjid=${1//_/}

docker run --rm --user $(id -u):$(id -g) --network none -v /opt/bids/dicoms:/data:ro -v /home/mibackup/bids/heuristic.py:/heuristic.py -v /opt/bids:/output nipy/heudiconv:latest -d /data/{subject}/*/*/*.dcm -s $1 -f /heuristic.py -b --minmeta --overwrite -o /output
docker run --rm --user $(id -u):$(id -g) --network none -v /opt/bids:/data:ro -v /opt/bids/mriqc_12:/out poldracklab/mriqc:0.12.1 /data /out participant --participant-label $subjid
docker run --rm --user $(id -u):$(id -g) --network none -v /opt/bids:/data:ro -v /opt/bids/mriqc_12:/out poldracklab/mriqc:0.12.1 /data /out group

docker run --rm --user $(id -u):$(id -g) --network none -v /opt/bids:/data:ro -v /opt/bids/mriqc:/out poldracklab/mriqc:0.15.0 /data /out participant --participant-label $subjid
docker run --rm --user $(id -u):$(id -g) --network none -v /opt/bids:/data:ro -v /opt/bids/mriqc:/out poldracklab/mriqc:0.15.0 /data /out group
