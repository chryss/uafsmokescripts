#!/bin/bash -l
module purge
module load python

source activate py27_uafsmoke
cd /center1/d/UAFSMOKE/src/smokescripts2015
python syncfirms.py
source deactivate
