#!/bin/bash -l
module purge
module load python
module load proj

cd /u1/uaf/waigl/virtualenvs/scipy2_sitepack/bin
source activate

cd /datadir/UAFSMOKE/src/smokescripts2015
python syncfirms.py
