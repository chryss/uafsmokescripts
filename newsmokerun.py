#!/usr/bin/env python

from __future__ import print_function, division
import os
import glob
import argparse
import datetime as dt

DATEPATTERN = "%Y%m%d"
DATEPATTERN_HYPH = "%Y-%m-%d"
DATETIMEPATTERN = "%Y-%m-%d_%H:%M:%S"
TODAY = dt.datetime.utcnow()
DATESTAMP1 = TODAY.strftime(DATEPATTERN)
DEFAULTDAYS = 3
DEFAULTSCRIPT = 'wrf_uafsmokerun.pbs'
TEMPLATEDIR = 'TEMPLATES'

def parse_arguments():
    """Parse arguments"""
    parser = argparse.ArgumentParser(description='Prepare "extra" input files for prep_chem_sources')
    parser.add_argument('--date',  
        help='startdate to run')
    parser.add_argument('--days',  
        help='how many days to run',
        default=DEFAULTDAYS,
        type=int)
    parser.add_argument('--scriptname',
        help='torque script name',
        default=DEFAULTSCRIPT)
    return parser.parse_args()

files = os.listdir(TEMPLATEDIR)
args = parse_arguments()
startdatetime = dt.datetime.strptime(args.date, DATEPATTERN)
enddatetime = startdatetime + dt.timedelta(days=args.days)

parameters = {}
parameters['fromdatetime'] = startdatetime.strftime(DATETIMEPATTERN)
parameters['fromdate'] = startdatetime.strftime(DATEPATTERN_HYPH)
parameters['todatetime'] = enddatetime.strftime(DATETIMEPATTERN)
parameters['fromyear'] = str(startdatetime.year)
parameters['frommonth'] = str(startdatetime.month).zfill(2)
parameters['fromday'] = str(startdatetime.day).zfill(2)
parameters['toyear'] = str(enddatetime.year)
parameters['tomonth'] = str(enddatetime.month).zfill(2)
parameters['today'] = str(enddatetime.day).zfill(2)
parameters['hours'] = str(args.days * 24)
parameters['torquescript'] = args.scriptname

for item in parameters:
    print(item, parameters[item])

for fn in files:
    with open(os.path.join(TEMPLATEDIR, fn), 'rU') as src:
        with open(fn, 'w') as target:
            target.write(src.read().format(**parameters))
