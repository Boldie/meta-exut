FILESEXTRAPATHS_prepend := "${THISDIR}/linux-stm32mp:"
KERNEL_CONFIG_FRAGMENTS += "${WORKDIR}/fragments/4.19/fragment-dm.config"
SRC_URI_append = " file://4.19/fragment-dm.config;subdir=fragments "
