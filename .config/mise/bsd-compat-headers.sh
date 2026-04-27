#!/bin/sh
[ ! -r env/bsd-compat-headers ] || . env/bsd-compat-headers
[ -z "${BSD_COMPAT_HEADERS_VERSION}" ] || [ ! "${BSD_COMPAT_HEADERS_VERSION_PREV}" = "${BSD_COMPAT_HEADERS_VERSION}" ] || exit 0

export BSD_COMPAT_HEADERS_VERSION_PREV="${BSD_COMPAT_HEADERS_VERSION}"

# Update the vendored bsd-compat-headers
(
  cd "../../vendor"
  find -not -name "bsd-compat-headers-${BSD_COMPAT_HEADERS_VERSION}.tar" -a -name "bsd-compat-headers-*.tar" -delete
  [ -r "bsd-compat-headers-${BSD_COMPAT_HEADERS_VERSION}.tar" ] \
    || http -F -d --ignore-stdin \
    -o "bsd-compat-headers-${BSD_COMPAT_HEADERS_VERSION}.tar" \
    "https://dl-cdn.alpinelinux.org/latest-stable/main/x86_64/bsd-compat-headers-${BSD_COMPAT_HEADERS_VERSION}.apk"
)

cat <<EOF >env/bsd-compat-headers
BSD_COMPAT_HEADERS_VERSION_PREV="${BSD_COMPAT_HEADERS_VERSION}"
BSD_COMPAT_HEADERS_VERSION="${BSD_COMPAT_HEADERS_VERSION}"
EOF
