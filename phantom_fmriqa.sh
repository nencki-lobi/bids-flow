#!/bin/bash
cd /opt/phantom/dicoms/$1
find . -type d -iname ep2d_bold_ldt_audio -exec docker run -it --rm -v /opt/phantom/dicoms/$1/{}:/home/input fmriqa \;
find . -type d -iname fmriqa -exec cp -r --parents {} /opt/phantom/reports/ \;

cd /opt/phantom/reports
python ~/bids/bxh-xcede/qaplotter.py . qa_year 12
python ~/bids/bxh-xcede/qaplotter.py . qa_3m 3
