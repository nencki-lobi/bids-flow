#! /bin/bash

# Configure PATH
export PATH=$PATH:/opt/bxh_xcede_tools-1.11.14-lsb30.x86_64/bin
source /etc/afni/afni.sh

cd /home/input
#1 remove old files
rm dicoms.bxh
rm -r fmriqa
#2 convert to bxh
dicom2bxh *.dcm dicoms.bxh
#3 analyze
csh -c "fmriqa_phantomqa.pl dicoms.bxh fmriqa"
