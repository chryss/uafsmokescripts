#!/bin/bash

SCRIPTDIR=/center1/UAFSMOKE/UAFSMOKE/src/scripts
WRFDIR=/center1/UAFSMOKE/UAFSMOKE/src/WRFV3/test/em_real/
FLAG=POSTPROCESS.ME
LOCK=POSTPROCESS.LOCK

FILE=${WRFDIR}${FLAG}
cd ${SCRIPTDIR}
if [ -f $FILE ] && [ ! -f $LOCK ]; then
    touch $LOCK
    bash ./postprocess.sh
fi
cd ${SCRIPTDIR}
rm $LOCK
rm $FILE
