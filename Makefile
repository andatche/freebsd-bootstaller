.POSIX:

all: build

.PHONY: all workdir download build clean

MIRROR?=ftp.freebsd.org
ARCH?=amd64
VERSION?=10.1-RELEASE

WRKDIR?=${PWD}/tmp/${VERSION}-${ARCH}
DSTDIR?=${WRKDIR}/dist
BASE?=${DSTDIR}
CFGDIR?=${PWD}/mfsbsd-conf
PKG_STATIC?=/usr/local/sbin/pkg-static
PACKAGESDIR?=${PWD}/mfsbsd-packages
IMAGE=${PWD}/freebsd-bootstaller-${VERSION}-${ARCH}.img

workdir: ${WRKDIR} ${DSTDIR}
${WRKDIR}:
	@mkdir -p $@
${DSTDIR}:
	@mkdir -p $@

download: workdir ${WRKDIR}/.download_done
${WRKDIR}/.download_done:
	@fetch -o ${DSTDIR}/base.txz http://${MIRROR}/pub/FreeBSD/releases/${ARCH}/${VERSION}/base.txz
	@fetch -o ${DSTDIR}/kernel.txz http://${MIRROR}/pub/FreeBSD/releases/${ARCH}/${VERSION}/kernel.txz
	@touch $@

build: download ${WRKDIR}/.build_done
${WRKDIR}/.build_done:
	@make -C mfsbsd BASE=${BASE} WRKDIR=${WRKDIR} PACKAGESDIR=${PACKAGESDIR} PKG_STATIC=${PKG_STATIC} CFGDIR=${CFGDIR} IMAGE=${IMAGE}
	@touch $@

clean:
	@if [ -d ${WRKDIR} ]; then make -C mfsbsd clean WRKDIR=${WRKDIR}; rm -rf ${WRKDIR}; fi
	@if [ -f ${IMAGE} ]; then rm ${IMAGE}; fi
