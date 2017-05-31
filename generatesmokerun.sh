#!/bin/bash
# run this once all namelists are updated and input is generated:
# 1. PCR namelist (prep_chem_sources.inp)
# 2. WPS namelist (namelist.wps)
# 3. WRF namelist - 2 versions w/ & w/o chemistry

SCRIPTDIR=`pwd`
PCSDIR=/center1/d/UAFSMOKE/src/PREP-CHEM-SRC-1.4/bin/
WPSDIR=/center1/d/UAFSMOKE/src/WPS351
WRFRUNDIR=/center1/d/UAFSMOKE/src/WRFV351/test/em_real

module purge
module load python

#if [ $# -lt 2 ]; then
#    echo "Usage: generatesmokerun.sh DATE DAYS [TORQUESCRIPT]"
#    exit 1
#elif [ $# -ge 3 ]; then
#    TORQUESCRIPT="--scriptname $3"
#fi
RUNDATE=$1
RUNDAYS=$2

echo "Generating namelists."
CMD="python newsmokerun.py --date $RUNDATE --days $RUNDAYS $TORQUESCRIPT"
echo $CMD
eval $CMD
echo "Moving namelist in place"
mv prep_chem_sources.inp $PCSDIR
mv namelist.input.* $WRFRUNDIR
mv namelist.wps $WPSDIR

module purge
module load PrgEnv-pgi
module load netcdf
module load hdf5
module load ncview

cd $PCSDIR
echo "`date`: In $PCSDIR"
./prep_chem_sources_RADM_WRF_FIM.exe

cd $WPSDIR
echo "`date`: In $WPSDIR"
#rm GRIBFILE.*
rm met_em.d*
rm FILE*
#./link_grib.csh gfs/gfs*
./ungrib.exe
./metgrid.exe

cd $SCRIPTDIR
/bin/bash launchsmokerun.sh
