#!/bin/bash -l
module purge
module load python

source activate py27_uafsmoke
cd /center1/d/UAFSMOKE/src/scripts
python syncfirms.py --archive --days 5
cd /center1/d/UAFSMOKE/dat/fires_data/FIRMS_MODIS
python preparefiresource_coarse.py --date `date -u +%Y%m%d`
cd /center1/d/UAFSMOKE/dat/fires_data/FIRMS_VIIRS-I
python preparefiresource_coarse.py --date `date -u +%Y%m%d`
source deactivate
