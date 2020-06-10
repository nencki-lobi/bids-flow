#!/bin/bash

subjid=${1//_/}

#heudiconv
docker run --rm --user $(id -u):$(id -g) --network none -v /srv/mriqc/dicoms:/data:ro -v /home/bkossows/bids-flow/heuristic.py:/heuristic.py -v /srv/mriqc:/output nipy/heudiconv:0.5.4 --files /data/$1 -f /heuristic.py -b --minmeta --overwrite -o /output
#mriqc
#docker run --rm --user $(id -u):$(id -g) --network none -v /srv/mriqc:/data:ro -v /srv/mriqc/reports:/out poldracklab/mriqc:0.15.0 --fd_thres 0.5 /data /out participant --participant-label $subjid
#docker run --rm --user $(id -u):$(id -g) --network none -v /srv/mriqc:/data:ro -v /srv/mriqc/reports:/out poldracklab/mriqc:0.15.0 --fd_thres 0.5 /data /out group
