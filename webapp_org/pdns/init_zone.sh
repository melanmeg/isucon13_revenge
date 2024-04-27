#!/usr/bin/env bash

set -eux
cd $(dirname $0)

if test -f /home/isucon/env.sh; then
	. /home/isucon/env.sh
fi

ISUCON_SUBDOMAIN_ADDRESS=${ISUCON13_POWERDNS_SUBDOMAIN_ADDRESS:-127.0.0.1}

temp_dir=$(mktemp -d)
trap 'rm -rf $temp_dir' EXIT
sed 's/<ISUCON_SUBDOMAIN_ADDRESS>/'$ISUCON_SUBDOMAIN_ADDRESS'/g' u.isucon.local.zone > ${temp_dir}/u.isucon.local.zone
pdnsutil load-zone u.isucon.local ${temp_dir}/u.isucon.local.zone

