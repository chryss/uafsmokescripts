#!/bin/bash -l
# Retrieve the day's GFS forecast from Ji Zhang's download
TARGETDIR=/center1/d/UAFSMOKE/src/WPS/gfs
#scp waigl@pacman2.arsc.edu:/import/c/w/jizhang/rt_wrf/gribfiles-gfs/`date -u +"%Y%j"`00/gfs* .

while [[ $# -ge 1 ]]
do
    key="$1"
    case $key in
        -d|--directory)
            TARGETDIR=$2
            shift
            shift
            ;;
        *)
            break
            ;;
    esac
done

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

cd $TARGETDIR
rm -f gfs*
wget "ftp://ftpprd.ncep.noaa.gov/pub/data/nccf/com/gfs/prod/gfs.${DATESTAMP}${WHEN}/gfs.t${WHEN}z.pgrb2.0p50.f0??"
