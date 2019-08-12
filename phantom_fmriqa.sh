#!/bin/bash
cd /srv/fmriqa/dicoms/$1
echo FMRIQA
find . -type d -iname ep2d_bold_ldt_audio -exec docker run --rm -v /srv/fmriqa/dicoms/$1/{}:/home/input fmriqa \;
find . -type d -iname fmriqa -exec cp -r --parents {} /srv/fmriqa/reports/ \;

cd /srv/fmriqa/reports
python ~/bids-apps/bxh-xcede/qaplotter.py . qa_year 12
python ~/bids-apps/bxh-xcede/qaplotter.py . qa_3m 3
touch qa_year
touch qa_3m

