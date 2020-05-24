#!/bin/sh

set -e

if [ $# -eq 0 ]
  then
    echo "Usage: $0 <name>"
fi

lvcreate -V1G -T tank/tpool -n $1
mkdosfs /dev/mapper/tank-$1
