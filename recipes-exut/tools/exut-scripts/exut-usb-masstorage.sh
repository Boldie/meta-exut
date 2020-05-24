#!/bin/sh
set -x

configfs="/sys/kernel/config/usb_gadget"
g=g1
c=c.1
d="${configfs}/${g}"

VENDOR_ID="0xa4a2"
PRODUCT_ID="0x0525"

udc=$(ls -1 /sys/class/udc/)
if [ -z $udc ]; then
    echo "No UDC driver registered"
    exit 1
fi

do_start() {
	mkdir "${d}"
	echo ${VENDOR_ID} > "${d}/idVendor"
	echo ${PRODUCT_ID} > "${d}/idProduct"

	mkdir "${d}/configs/${c}"
	mkdir "${d}/functions/mass_storage.0"
	echo 1 > "${d}/functions/mass_storage.0/stall"
	echo "${IMAGE}" > "${d}/functions/mass_storage.0/lun.0/file"
	echo 1 > "${d}/functions/mass_storage.0/lun.0/removable"
	echo 0 > "${d}/functions/mass_storage.0/lun.0/cdrom"

	str="${d}/strings/0x409"
	mkdir "${str}"
	echo "${SERIAL}" > "${str}/serialnumber"
	echo "Developers Heaven" > "${str}/manufacturer"
	echo "Exchangeable USB Flash Tool" > "${str}/product"

	mkdir "${d}/configs/${c}/strings/0x409"
	echo "Conf 1" > "${d}/configs/${c}/strings/0x409/configuration"
	echo 120 > "${d}/configs/${c}/MaxPower"
	ln -s "${d}/functions/mass_storage.0" "${d}/configs/${c}"

	echo "${udc}" > "${d}/UDC"
}

do_stop() {
   echo "" > "${d}/UDC"

    rm -f "${d}/os_desc/${c}"
    [ -d "${d}/configs/${c}/mass_storage.0" ] &&rm -f "${d}/configs/${c}/mass_storage.0"

    [ -d "${d}/strings/0x409/" ] && rmdir "${d}/strings/0x409/"
    [ -d "${d}/configs/${c}/strings/0x409" ] && rmdir "${d}/configs/${c}/strings/0x409"
    [ -d "${d}/configs/${c}" ] && rmdir "${d}/configs/${c}"
    [ -d "${d}/functions/mass_storage.0" ] && rmdir "${d}/functions/mass_storage.0"
    [ -d "${d}" ] && rmdir "${d}"
}

SERIAL="12AB34CD56EF"
IMAGE=""

case $1 in
    start)
     	OPTIND=2
        while getopts "s::i:" arg; do
          case $arg in
            s)
              SERIAL="${OPTARG}"
              ;;
            i)
              IMAGE="${OPTARG}"
              ;;
          esac
        done
        echo "Start USB mass storage gadget"
        do_start $2
        ;;
    stop)
        echo "Stop USB mass storage gadget"
        do_stop
        ;;
    *)
        echo "Usage: $0 (stop | start)"
        ;;
esac

