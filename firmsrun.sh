#!/bin/bash -l
module purge
module load python

DATESTAMP=`date -u +%Y%m%d`

source activate py27_uafsmoke
cd /center1/UAFSMOKE/UAFSMOKE/src/scripts
python syncfirms.py --archive --days 5
cd /center1/UAFSMOKE/UAFSMOKE/dat/fires_data/FIRMS_MODIS
python preparefiresource_coarse.py --date $DATESTAMP
cd /center1/UAFSMOKE/UAFSMOKE/dat/fires_data/FIRMS_VIIRS-I
python preparefiresource_coarse.py --date $DATESTAMP
cd /center1/UAFSMOKE/UAFSMOKE/dat/fires_data/FIRMS_merged
awk 1 ../FIRMS_MODIS/FIRMS_${DATESTAMP}.dat ../FIRMS_VIIRS-I/FIRMS_${DATESTAMP}.dat AICC_Extra_${DATESTAMP}.dat > FIRMS_${DATESTAMP}.dat
source deactivate
