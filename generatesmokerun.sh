#!/bin/bash -l
# run this to update latest fire date & all namelists, and generate new launch script:
# 1. PCR namelist (prep_chem_sources.inp)
# 2. WPS namelist (namelist.wps)
# 3. WRF namelist - 2 versions w/ & w/o chemistry
# NOTE THAT meteorological input data  must be updated beforehand!

PCSDIR=/center1/UAFSMOKE/UAFSMOKE/src/PREP-CHEM-SRC-1.4_chinook/bin/
WPSDIR=/center1/UAFSMOKE/UAFSMOKE/src/WPS
WRFRUNDIR=/center1/UAFSMOKE/UAFSMOKE/src/WRFV3/test/em_real
NODEPLOY=0
RUNFIRMS=1

while [[ $# -ge 1 ]]
do
    key="$1"
    case $key in
        -n|--nofirms)
            RUNFIRMS=0
            shift
            ;;
        -t|--test)
            NODEPLOY=1
            shift
            ;;
        *)
            break
            ;;
    esac
done

if [ $# -gt 1 ]; then
    RUNDAYS=$2
    RUNDATE=$1
elif [ $# -gt 0 ]; then
    RUNDAYS=3
    RUNDATE=$1
else
    RUNDAYS=3
    RUNDATE=`date -u +"%Y%m%d"`
fi

if [ $RUNFIRMS -eq 1 ]; then
    # Step 1: update latest fire data
    /bin/bash -l firmsrun.sh
fi

# Step 2: generate latest namelists 
/bin/bash -l generatenamelists.sh $RUNDATE $RUNDAYS $3 

# Step 3: run preprocesors
/bin/bash -l runpreprocessors.sh

# Step 4: launch WRF
/bin/bash -l launchsmokerun.sh $NODEPLOY
