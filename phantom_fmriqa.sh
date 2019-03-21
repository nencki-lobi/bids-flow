#!/bin/bash

docker run -it --rm -v /opt/phantom/dicoms/$1/*/ep2d_bold_ldt_audio:/home/input fmriqa

cd /opt/phantom/dicoms
find . -type d -iname fmriqa -exec mv {} /opt/phantom/reports
