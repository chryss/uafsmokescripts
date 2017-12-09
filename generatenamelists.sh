#!/bin/bash -l
# run this to update all namelists & launch script:
# 1. PCR namelist (prep_chem_sources.inp)
# 2. WPS namelist (namelist.wps)
# 3. WRF namelist - 2 versions w/ & w/o chemistry
# Step 2 of full smoke run 

RUNDATE=$1
RUNDAYS=$2

module purge
module load lang/Anaconda3
source activate py27_uafsmoke

#if [ $# -lt 2 ]; then
#    echo "Usage: generatesmokerun.sh DATE DAYS [SLURMSCRIPT]"
#    exit 1
#elif [ $# -ge 3 ]; then
#    SLURMSCRIPT="--scriptname $3"
#fi

echo "Generating namelists."
CMD="python newsmokerun.py --date $RUNDATE --days $RUNDAYS $SLURMSCRIPT"
echo $CMD
eval $CMD

shift
shift
shift
source deactivate 
