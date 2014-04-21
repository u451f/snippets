#!/usr/bin/python

import sys
import Image
import ImageChops
import ImageStat
import time

def parse_options():
    if len(sys.argv) != 3:
        print "Usage: " + sys.argv[0] + " <img1> <img2>"
        sys.exit(1)

def compare_images(img1, img2):
    oldimg = Image.open(img1)
    newimg = Image.open(img2)
    diffimg = ImageChops.difference(newimg, oldimg)
    stats = ImageStat.Stat(diffimg)
    total = 0
    for var in stats.var:
        total += var
    return total == 0
 
if __name__ == "__main__":
    parse_options()
    rval = compare_images(sys.argv[1], sys.argv[2])
    if not rval:
        print "Images differ!"
    sys.exit(rval)
