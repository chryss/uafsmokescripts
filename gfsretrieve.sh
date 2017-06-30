#!/bin/bash -l
# Retrieve the day's GFS forecast from Ji Zhang's download
cd /center1/d/UAFSMOKE/dat/gfs
rm -f gfs*
#scp waigl@pacman2.arsc.edu:/import/c/w/jizhang/rt_wrf/gribfiles-gfs/`date -u +"%Y%j"`00/gfs* .

if [ $# -gt 1 ]; then
    WHEN=$2
    DATESTAMP=$1
elif [ $# -gt 0 ]; then
    WHEN=00
    DATESTAMP=$1
else
    WHEN=00
    DATESTAMP=`date -u +"%Y%m%d"`
fi

wget "ftp://ftpprd.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.${DATESTAMP}${WHEN}/gfs.t00z.pgrb2.0p50.f0??"
