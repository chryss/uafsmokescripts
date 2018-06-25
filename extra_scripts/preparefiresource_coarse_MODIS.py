#!/usr/bin/env python

from __future__ import print_function, division
import math
import os
import pandas
import argparse
import datetime as dt

PATAK = "MODIS_C6_Alaska_MCD14DL_NRT_{}.txt"
PATCA = "MODIS_C6_Canada_MCD14DL_NRT_{}.txt"
TODAY = dt.datetime.now()
DATESTAMP1 = TODAY.strftime("%Y%m%d")
DATESTAMP2 = TODAY.strftime("%Y%j")
FNPAT = "FIRMS_{}.dat"
EXTRAPAT = "AICC_Extra_{}.dat"
P = 0.2


def parse_arguments():
    """Parse arguments"""
    parser = argparse.ArgumentParser(description='Prepare "extra" input files for prep_chem_sources')
    parser.add_argument('--date',  
        help='date to run',
        default=DATESTAMP1)
    return parser.parse_args()

args = parse_arguments()
refdate = dt.datetime.strptime(args.date, "%Y%m%d").date()
prevdate = refdate - dt.timedelta(days=1)
datestamp2 = refdate.strftime("%Y%j")
datestamp3 = prevdate.strftime("%Y%j")
print("Reference date is: {}".format(refdate))
print("Working on: ", PATAK.format(datestamp2), PATCA.format(datestamp2))
print("Previous UTC date: ", PATAK.format(datestamp3), PATCA.format(datestamp3))

dfs = []

try:
    df1 = pandas.read_csv(PATAK.format(datestamp2))
    dfs.append(df1)
except IOError:
    print("Data file unavailable: {}".format(PATAK.format(datestamp2)))
try:
    df2 = pandas.read_csv(PATCA.format(datestamp2))
    dfs.append(df2[(df2.latitude > 60.0) & (df2.longitude < -130.)])
except IOError:
    print("Data file unavailable: {}".format(PATCA.format(datestamp2)))
try:
    df3 = pandas.read_csv(PATAK.format(datestamp3))
    dfs.append(df3[df3.acq_time > " 12:00"])
except IOError:
    print("Data file unavailable: {}".format(PATAK.format(datestamp3)))
try:
    df4 = pandas.read_csv(PATCA.format(datestamp3))
    dfs.append(df4[(df4.acq_time > " 12:00") & (df4.latitude > 60.0) & (df4.longitude < -130.)])
except IOError:
    print("Data file unavailable: {}".format(PATCA.format(datestamp3)))

data = pandas.concat(dfs)

data['firearea'] = P*data['scan']*data['track']
#data['firearea'] = .228

with open(FNPAT.format(args.date), 'w') as dest:
    print("Saving data to file {}.".format(FNPAT.format(args.date)))
    data.to_csv(
        dest,
        header=False, 
        columns=['longitude', 'latitude', 'firearea'], 
        index=False,
        sep=' ')
    if os.path.exists(EXTRAPAT.format(args.date)):
        print("Adding in AICC fire sources")
        with open(EXTRAPAT.format(args.date)) as source:
            for line in source:
                dest.write(line)
