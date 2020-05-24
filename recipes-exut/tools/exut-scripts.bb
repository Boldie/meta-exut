DESCRIPTION = "Shell script to enable/disable usb mass storage gadget"
HOMEPAGE = "www.steckmann.de"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "file://exut-usb-masstorage.sh file://exut-init-image.sh"

do_install() {
    install -d ${D}${base_sbindir}
    install -m 755 ${WORKDIR}/exut-usb-masstorage.sh ${D}${base_sbindir}
    install -m 755 ${WORKDIR}/exut-init-image.sh ${D}${base_sbindir}
}

FILES_${PN} += "${base_sbindir}"
