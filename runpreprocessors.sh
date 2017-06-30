#!/bin/bash -l 
# move namelists in place and run preprocessors: 
# 1. PCR namelist (prep_chem_sources.inp)
# 2. WPS namelist (namelist.wps)
# 3. WRF namelist - 2 versions w/ & w/o chemistry
# Step 3 of full smoke run

SCRIPTDIR=`pwd`
PCSDIR=/center1/d/UAFSMOKE/src/PREP-CHEM-SRC-1.4_chinook/bin/
WPSDIR=/center1/d/UAFSMOKE/src/WPS
WRFRUNDIR=/center1/d/UAFSMOKE/src/WRFV3/test/em_real

module purge
module load toolchain/pic-intel/2016b
module load data/netCDF-Fortran/4.4.4-pic-intel-2016b
module load data/netCDF-C++4/4.3.0-pic-intel-2016b
module load vis/JasPer/1.900.1-pic-intel-2016b
module load lib/libpng/1.6.24-pic-intel-2016b
module list

# move namelists in place
mv prep_chem_sources.inp $PCSDIR
mv namelist.input.uafsmoke* $WRFRUNDIR
mv namelist.wps $WPSDIR

# run preprocesors
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
