#!/bin/bash -l
# Second part of smoke run launching - this part is generated by script and has run date in it

WRFRUNDIR=/center1/UAFSMOKE/UAFSMOKE/src/WRFV351/test/em_real
SCRIPTDIR=/center1/UAFSMOKE/UAFSMOKE/src/scripts
NODEPLOY=$1
module load slurm

mv namelist.input.uafsmoke* $WRFRUNDIR
cd $WRFRUNDIR
echo "`date`: In $WRFRUNDIR"
rm wrfbdy_d01
rm wrfchemi_d01
rm wrfchemi_gocart_bg_d01
rm wrffirechemi_d01
rm wrfinput_d01
rm wrf_chem_input_d01
rm met_em.d*
rm rsl.*
ln -sf /center1/UAFSMOKE/UAFSMOKE/src/PREP-CHEM-SRC-1.4_chinook/bin/wrf_chemi_input-T-2017-12-01-000000-g1-gocartBG.bin wrf_gocart_backg
ln -sf /center1/UAFSMOKE/UAFSMOKE/src/PREP-CHEM-SRC-1.4_chinook/bin/wrf_chemi_input-T-2017-12-01-000000-g1-bb.bin emissfire_d01
ln -sf /center1/UAFSMOKE/UAFSMOKE/src/PREP-CHEM-SRC-1.4_chinook/bin/wrf_chemi_input-T-2017-12-01-000000-g1-ab.bin emissopt3_d01
ln -sf /center1/UAFSMOKE/UAFSMOKE/src/WPS/met_em.d* .
ln -sf /center1/UAFSMOKE/UAFSMOKE/run/wrfout/2017_singles/wrfout_d01_2017-12-01_00:00:00 wrf_chem_input_d01

echo "`date`: Submitting job."
jid1=`sbatch wrf_uafsmoke_dev.slurm`
echo ${jid1:20}
if [ $NODEPLOY -eq 0 ]; then
    cd $SCRIPTDIR
    jid2=$(sbatch --dependency=afterok:${jid1:20} postprocess.slurm)
    echo ${jid2:20}
fi
