#!/usr/bin/env python

from __future__ import print_function, unicode_literals
import datetime as dt
import os
import ftputil

SERVER = "nrt1.modaps.eosdis.nasa.gov"
UN = "cwaigl"
PW = "Gerund10"
RPTH0 = "FIRMS"
RPTH1 = "Alaska"
RPTH2 = "Canada"
LOCALDIR = "/datadir/UAFSMOKE/dat/fires_data/FIRMS_MOD14"

def getfiles(area="Alaska"):

    localfiles = os.listdir('.')
    with ftputil.FTPHost(SERVER, UN, PW) as host:
        path = os.path.join(RPTH0, area)
        host.chdir(path)
        names = host.listdir(host.curdir)
        for fn in names:
            if fn not in localfiles:
                print("Getting {}".format(fn))
                host.download(fn, fn)

def main():
    os.chdir(LOCALDIR)
    getfiles(RPTH1)
    getfiles(RPTH2)

if __name__ == "__main__":
    main()
