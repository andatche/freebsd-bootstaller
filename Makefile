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
	@make -C mfsbsd BASE=${BASE} WRKDIR=${WRKDIR} CFGDIR=${CFGDIR} IMAGE=${PWD}/freebsd-bootstaller-${VERSION}-${ARCH}.img
	@touch $@

clean:
	@chflags -R noschg ${WRKDIR}
	@rm -fr ${WRKDIR}
	@make -C mfsbsd clean
