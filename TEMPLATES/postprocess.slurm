#!/bin/bash
#SBATCH --partition=debug
#SBATCH --ntasks=1
#SBATCH --tasks-per-node=1
#SBATCH --mail-user=cwaigl@alaska.edu
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --output=uafsmoke_postprocess.%j

WRFRUNDIR=/center1/d/UAFSMOKE/src/WRFV351/test/em_real
WRFOUTDIR=/center1/d/UAFSMOKE/run/wrfout
VIZDIR=/center1/d/UAFSMOKE/src/webimages/latest
FROMDATE={fromyear:s}{frommonth:s}{fromday:s}

module load data/NCL/6.3.0-binary-rhel6

mkdir -p "$WRFOUTDIR"/"$FROMDATE"00
cp $WRFRUNDIR/wrfout_d01_{todatetime:s} /center1/d/UAFSMOKE/run/wrfout/2017_singles/
mv $WRFRUNDIR/wrfout_d01_* "$WRFOUTDIR"/"$FROMDATE"00/

cd $VIZDIR
./smokeplotter.sh -d "$FROMDATE"00
