#!/bin/bash

subjid=${1//_/}

docker run --rm --user $(id -u):$(id -g) --network none -v /srv/mriqc/dicoms:/data:ro -v /home/bkossows/bids-flow/heuristic.py:/heuristic.py -v /srv/mriqc:/output nipy/heudiconv:0.5.4 -d /data/{subject}/*/*/*.dcm -s $1 -f /heuristic.py -b --minmeta --overwrite -o /output
#docker run --rm --user $(id -u):$(id -g) --network none -v /srv/mriqc:/data:ro -v /opt/bids/mriqc_12:/out poldracklab/mriqc:0.12.1 /data /out participant --participant-label $subjid
#docker run --rm --user $(id -u):$(id -g) --network none -v /srv/mriqc:/data:ro -v /opt/bids/mriqc_12:/out poldracklab/mriqc:0.12.1 /data /out group

docker run --rm --user $(id -u):$(id -g) --network none -v /srv/mriqc:/data:ro -v /srv/mriqc/reports:/out poldracklab/mriqc:0.15.0 --fd_thres 0.5 /data /out participant --participant-label $subjid
docker run --rm --user $(id -u):$(id -g) --network none -v /srv/mriqc:/data:ro -v /srv/mriqc/reports:/out poldracklab/mriqc:0.15.0 --fd_thres 0.5 /data /out group
