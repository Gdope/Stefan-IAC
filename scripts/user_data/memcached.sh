#!/bin/bash
set -e

exec > /var/log/user-data.log 2>&1

echo "=== MEMCACHED USER DATA START ==="

retry() {
  local n=1
  local max=5
  local delay=10
  while true; do
    "$@" && break || {
      if [[ $n -lt $max ]]; then
        echo "Command failed. Attempt $n/$max..."
        ((n++))
        sleep $delay
      else
        echo "Command failed after $n attempts."
        return 1
      fi
    }
  done
}

echo "Waiting for internet connectivity..."
retry ping -c 3 google.com

echo "Updating packages..."
retry apt-get update -y

echo "Installing memcached..."
retry apt-get install -y memcached

echo "Configuring memcached to listen on all interfaces..."
sed -i 's/^-l 127.0.0.1/-l 0.0.0.0/' /etc/memcached.conf

echo "Enabling and starting memcached..."
systemctl enable memcached
systemctl start memcached
systemctl restart memcached

echo "Checking memcached status..."
systemctl status memcached --no-pager

echo "=== MEMCACHED USER DATA FINISHED SUCCESSFULLY ==="