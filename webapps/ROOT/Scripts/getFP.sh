#!/bin/bash

set -x 
exec 2> /tmp/getFP.log
DATE=$1

su - admin -c "/usr/bin/ph/fingerprint/bin/getFPdata.sh $DATE"
