#!/bin/bash -l
module purge
module load lang/Anaconda3

DATESTAMP=`date -u +%Y%m%d`

source activate py27_uafsmoke
cd /center1/UAFSMOKE/UAFSMOKE/src/scripts
python syncfirms.py --archive --days 5
cd /center1/UAFSMOKE/UAFSMOKE/dat/fires_data/FIRMS_MODIS
python preparefiresource_coarse.py --date $DATESTAMP
cd /center1/UAFSMOKE/UAFSMOKE/dat/fires_data/FIRMS_VIIRS-I
python preparefiresource_coarse.py --date $DATESTAMP
cd /center1/UAFSMOKE/UAFSMOKE/dat/fires_data/FIRMS_merged
if [ -e AICC_Extra_${DATESTAMP} ]; then
   EXTRAFILE="AICC_Extra_${DATESTAMP}.dat"  
fi
awk 1 ../FIRMS_MODIS/FIRMS_${DATESTAMP}.dat ../FIRMS_VIIRS-I/FIRMS_${DATESTAMP}.dat ${EXTRAFILE} > FIRMS_${DATESTAMP}.dat
source deactivate
