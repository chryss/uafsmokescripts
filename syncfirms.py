#!/usr/bin/env python

from __future__ import print_function, unicode_literals
import datetime as dt
import os
import glob
import shutil
import ftputil
import argparse
from credentials import FIRMS
from time import sleep

SERVER = FIRMS["server"]
UN = FIRMS['username']
PW = FIRMS['cred']
RPTH0 = "FIRMS"
PROD = {'MODIS': 'c6',
    'VIIRS-I': 'viirs' 
}
LOCPTH = ['Alaska', 'Canada']
LOCALDIR = "/center1/UAFSMOKE/UAFSMOKE/dat/fires_data/"
DEFAULTDAYS = 3
ARCHIVE = 'archive'

def parse_arguments():
    """Parse arguments"""
    parser = argparse.ArgumentParser(description='Sync near real-time (NRT) fire products from FIRMS')
    parser.add_argument('--days',  
        help='how many most recent days to retrieve',
        default=DEFAULTDAYS,
        type=int)
    parser.add_argument('--archive',
            help='archive all existing',
            action='store_true')
    parser.add_argument('--nc',
            help= 'do not clobber',
            action='store_true')
    return parser.parse_args()

def getfiles(prod='c6', area="Alaska", days=DEFAULTDAYS, noclobber=False):
    localfiles = os.listdir('.')
    selectfiles = []
    today = dt.datetime.utcnow()
    daypatt = []
    for delta in range(days):
        newjulian = (today - dt.timedelta(days=delta)).strftime('%Y%j.txt')
        daypatt.append(newjulian)
    with ftputil.FTPHost(SERVER, UN, PW) as host:
        path = os.path.join(RPTH0, prod, area)
        host.chdir(path)
        names = host.listdir(host.curdir)
        for patt in daypatt:
            for name in names:
                if name.endswith(patt):
                    if noclobber:
                        if name in localfiles:
                            continue
                    selectfiles.append(name)
        for fn in selectfiles:
            host.download(fn, fn)
            print("Retrieved {}".format(fn))

def main():
    args = parse_arguments()
    if args.archive:
        for prodname in PROD:
            workingdir = os.path.join(LOCALDIR, RPTH0+'_'+prodname)
            os.chdir(workingdir)
            files = glob.glob('*.txt')
            print(files)
            for fn in files:
                if os.path.exists(os.path.join(workingdir, ARCHIVE, fn)):
                    os.remove(os.path.join(workingdir, ARCHIVE, fn))
                shutil.move(fn, os.path.join(workingdir, ARCHIVE))
                print("Archived {}.".format(fn))
    
    while True:
        try:
            for prodname in PROD:
                newdir = os.path.join(LOCALDIR, RPTH0+'_'+prodname)
                os.chdir(newdir)
                for area in LOCPTH:
                    print("Retrieving {}, {}".format(prodname, area))
                    getfiles(prod=PROD[prodname], area=area, days=args.days, noclobber=args.nc)
        except ftputil.error.FTPIOError:
            print("Retrying...")
            sleep(5)
        else:
            return

if __name__ == "__main__":
    main()
