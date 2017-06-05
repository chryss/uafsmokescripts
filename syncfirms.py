#!/usr/bin/env python

from __future__ import print_function, unicode_literals
import datetime as dt
import os
import ftputil
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
LOCALDIR = "/center1/d/UAFSMOKE/dat/fires_data/"

def getfiles(prod='c6', area="Alaska"):
    localfiles = os.listdir('.')
    with ftputil.FTPHost(SERVER, UN, PW) as host:
        path = os.path.join(RPTH0, prod, area)
        host.chdir(path)
        names = host.listdir(host.curdir)
        for fn in names:
            if fn not in localfiles:
                host.download(fn, fn)
                print("Retrieved {}".format(fn))

def main():
    while True:
        try:
            for prodname in PROD:
                newdir = os.path.join(LOCALDIR, RPTH0+'_'+prodname)
                os.chdir(newdir)
                for area in LOCPTH:
                    print("Retrieving {}, {}".format(prodname, area))
                    getfiles(prod=PROD[prodname], area=area)
        except ftputil.error.FTPIOError:
            print("Retrying...")
            sleep(5)
        else:
            return

if __name__ == "__main__":
    main()
