#!/bin/bash -l

WRFRUNDIR=/center1/UAFSMOKE/UAFSMOKE/src/WRFV351/test/em_real
WRFOUTDIR=/center1/UAFSMOKE/UAFSMOKE/run/wrfout
VIZDIR=/center1/UAFSMOKE/UAFSMOKE/src/webimages/latest
FROMDATE=20171201

module load data/NCL/6.3.0-binary-rhel6

mkdir -p "$WRFOUTDIR"/"$FROMDATE"00
cp $WRFRUNDIR/wrfout_d01_2017-12-04_00:00:00 /center1/UAFSMOKE/UAFSMOKE/run/wrfout/2017_singles/
mv $WRFRUNDIR/wrfout_d01_* "$WRFOUTDIR"/"$FROMDATE"00/

cd $VIZDIR
bash smokeplotter.sh $FROMDATE
