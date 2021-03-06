#!/bin/bash

proto="$(echo $HTTP_PROXY | grep :// | sed -e's,^\(.*://\).*,\1,g')"
# remove the protocol
url="$(echo ${HTTP_PROXY/$proto/})"

# extract the user (if any)
userpass="$(echo $url | grep @ | cut -d@ -f1)"
PROXY_PASS="$(echo $userpass | grep : | cut -d: -f2)"

if [ -n "$PROXY_PASS" ]; then
  PROXY_USER="$(echo $userpass | grep : | cut -d: -f1)"
else
    PROXY_USER=$userpass
fi

#extract the host & port
hostport="$(echo ${url/$userpass/} | cut -d@ -f2)"
PROXY_HOST="$(echo $hostport |  cut -d: -f1)"
PROXY_PORT="$(echo $hostport |  cut -d: -f2)"


/bin/socat TCP-L:$LOCAL_PORT,fork,reuseaddr PROXY:$PROXY_HOST:$DEST_HOST:$DEST_PORT,proxyport=$PROXY_PORT,proxyauth=$PROXY_USER:$PROXY_PASS
