#!/bin/sh

export PATH=$PATH:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin

#
# locale
#

export LANG="C.UTF-8"
export LC_ALL="C.UTF-8"

#
# app
#

export LIGHTNING_TIP_ENV="dev"
export LIGHTNING_TIP_LOG_FORMAT="Bracket" # Bracket | JSON
export LIGHTNING_TIP_LIBPQ_CONN_STR="postgresql://nixbld1@localhost/lightning-tip"
export LIGHTNING_TIP_ENDPOINT_PORT="4000"
