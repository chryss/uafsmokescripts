#!/bin/bash
# Retrieve the day's GFS forecast from Ji Zhang's download
cd /center1/d/UAFSMOKE/dat/gfs
rm -f gfs*
scp waigl@pacman2.arsc.edu:/import/c/w/jizhang/rt_wrf/gribfiles-gfs/`date +"%Y%j"`00/gfs* .
