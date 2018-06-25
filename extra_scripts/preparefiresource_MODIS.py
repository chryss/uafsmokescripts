#!/usr/bin/env python

from __future__ import print_function, division
import math
import pandas
import argparse
import datetime as dt

PATAK = "Alaska_MCD14DL_{}.txt"
PATCA = "Canada_MCD14DL_{}.txt"
TODAY = dt.datetime.now()
DATESTAMP1 = TODAY.strftime("%Y%m%d")
DATESTAMP2 = TODAY.strftime("%Y%j")
FNPAT = "FIRMS_{}.dat"
K2 = 3634.173
TAU = 0.8

def parse_arguments():
    """Parse arguments"""
    parser = argparse.ArgumentParser(description='Prepare "extra" input files for prep_chem_sources')
    parser.add_argument('--date',  
        help='date to run',
        default=DATESTAMP1)
    return parser.parse_args()

def partialarea(TB, Tfire=700):
    return (math.exp(K2/Tfire) - 1)/(TAU*(math.exp(K2/TB) - 1))

args = parse_arguments()
refdate = dt.datetime.strptime(args.date, "%Y%m%d").date()
prevdate = refdate - dt.timedelta(days=1)
datestamp2 = refdate.strftime("%Y%j")
datestamp3 = prevdate.strftime("%Y%j")
print("Reference date is: {}".format(refdate))
print("Working on: ", PATAK.format(datestamp2), PATCA.format(datestamp2))
print("Previous UTC date: ", PATAK.format(datestamp3), PATCA.format(datestamp3))

df1 = pandas.read_csv(PATAK.format(datestamp2))
df1 = df1[df1.acq_time < " 12:00"]
df2 = pandas.read_csv(PATCA.format(datestamp2))
df2 = df2[df2.acq_time < " 12:00"]
df3 = pandas.read_csv(PATAK.format(datestamp3))
df3 = df3[df3.acq_time > " 12:00"]
df4 = pandas.read_csv(PATCA.format(datestamp3))
df4 = df4[df4.acq_time > " 12:00"]
data = pandas.concat([df1, df2, df3, df4])

data['partialarea'] = pandas.Series([partialarea(temp, Tfire=700) for temp in data['brightness']])
data['firearea'] = data['partialarea']*data['scan']*data['track']

data.to_csv(
        FNPAT.format(args.date), 
        header=False, 
        columns=['longitude', 'latitude', 'firearea'], 
        index=False,
        sep=' ')
