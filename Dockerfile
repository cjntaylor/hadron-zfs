#syntax=docker/dockerfile:latest

###################################################################################################
###################################################################################################
FROM toolchain AS builder

ARG TARGETARCH
COPY --chown=root:root --chmod=0755 <<EOF /usr/bin/linux-arch
#!/bin/sh
case "${TARGETARCH}" in
  amd64  ) echo "x86"   ;;
  arm    ) echo "arm"   ;;
  arm64  ) echo "arm64" ;;
  riscv64) echo "riscv" ;;
esac
EOF

WORKDIR /output
WORKDIR /build

# Setup the kernel sources for building
ARG HADRON_KERNEL_VERSION
ADD vendor/linux-${HADRON_KERNEL_VERSION}.tar.xz /build/
WORKDIR /build/linux-${HADRON_KERNEL_VERSION}
RUN cp /usr/share/kernel-misc/kernel-config .config
ARG VARIANT_ARCH_LINUX
RUN ./scripts/config --enable MODULE_SIG_ALL
RUN ARCH=$(linux-arch) make -s olddefconfig
RUN ARCH=$(linux-arch) make -s -j$(nproc) modules_prepare
RUN cp /usr/share/kernel-misc/Module.symvers .

# Fix broken perl link
RUN ln -s ../bin/perl /usr/sbin/perl

# Build libtirpc for zfs
# Specifically build static+pic for linking into static zfs binaries
ARG BSD_COMPAT_HEADERS_VERSION
ADD vendor/bsd-compat-headers-${BSD_COMPAT_HEADERS_VERSION}.tar /
ARG LIBTIRPC_VERSION
ADD vendor/libtirpc-${LIBTIRPC_VERSION}.tar.bz2 /build/
WORKDIR /build/libtirpc-${LIBTIRPC_VERSION}
RUN ./configure \
  --prefix=/usr \
  --enable-shared=no \
  --enable-static=yes \
  --enable-pic=yes \
  --disable-gssapi
RUN make -j$(nproc)
RUN make install

# Build zfs modules and utilities
ARG OPENZFS_VERSION
ADD vendor/zfs-${OPENZFS_VERSION}.tar.gz /build/
WORKDIR /build/zfs-${OPENZFS_VERSION}
RUN ARCH=$(linux-arch) ./configure \
  --prefix=/usr \
  --enable-shared=no \
  --enable-static=yes \
  --enable-pic=yes \
  --enable-debug=no \
  --enable-pyzfs=no \
  --enable-sysvinit=no \
  --enable-pam=no \
  --with-mounthelperdir=/usr/bin \
  --with-udevdir=/usr/lib/udev \
  --with-linux=/build/linux-${HADRON_KERNEL_VERSION} \
  --with-linux-obj=/build/linux-${HADRON_KERNEL_VERSION} \
  --with-gnu-ld=no
RUN ARCH=$(linux-arch) make -j$(nproc)
RUN ARCH=$(linux-arch) DESTDIR=/output make install
RUN find /output/usr/sbin -mindepth 1 -maxdepth 1 -print -exec mv {} /output/usr/bin \;
RUN find /output/lib -mindepth 1 -maxdepth 1 -print -exec mv {} /output/usr/lib \;
# INFO: Trim unnecessary files from the output
# INFO: We don't need anything that would be used to compile or otherwise extend zfs
# INFO: All binaries are built statically so they have no extra dependencies
RUN rm -rf \
  /output/etc \
  /output/lib \
  /output/usr/etc/zfs/*.example \
  /output/usr/include \
  /output/usr/lib/*.{a,la} \
  /output/usr/lib/{dracut,pkgconfig} \
  /output/usr/sbin \
  /output/usr/share/{initramfs-tools,man} \
  /output/usr/share/zfs/{test-runner,zfs-tests,zfs-tests.sh} \
  /output/usr/src

###################################################################################################
###################################################################################################
FROM trusted AS hadron-extension

COPY --link --from=builder /output/ /
