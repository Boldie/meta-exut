# Copyright (C) 2016, STMicroelectronics - All Rights Reserved
# Released under the MIT license (see COPYING.MIT for the terms)

# Tools extracted from 96boards-tools https://github.com/96boards/96boards-tools
DESCRIPTION = "Tools for resizing the file system"
SECTION = "devel"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

# e2fsprogs for resize2fs
RDEPENDS_${PN} += " e2fsprogs-resize2fs "

SRC_URI = " file://resize-helper file://target-system-init.service file://target-system-init file://target-system-init.sh.in"

S = "${WORKDIR}/git"

inherit systemd update-rc.d

SYSTEMD_PACKAGES += " target-system-init "
SYSTEMD_SERVICE_${PN} = "target-system-init.service"
SYSTEMD_AUTO_ENABLE_${PN} = "enable"

do_install() {
    install -d ${D}${systemd_unitdir}/system ${D}${base_sbindir}
    install -m 0644 ${WORKDIR}/target-system-init.service ${D}${systemd_unitdir}/system
    install -m 0755 ${WORKDIR}/target-system-init ${D}${base_sbindir}
    install -m 0755 ${WORKDIR}/resize-helper ${D}${base_sbindir}

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/target-system-init.sh.in ${D}${sysconfdir}/init.d/target-system-init.sh

    sed -i -e "s:@sbindir@:${base_sbindir}:; s:@sysconfdir@:${sysconfdir}:" \
${D}${sysconfdir}/init.d/target-system-init.sh
}

INITSCRIPT_NAME = "target-system-init.sh"
INITSCRIPT_PARAMS = "start 22 5 3 ."
