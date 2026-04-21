#!/bin/bash
set -e

exec > /var/log/user-data.log 2>&1

echo "=== USER DATA START ==="

retry() {
  local n=1
  local max=10
  local delay=15
  while true; do
    "$@" && break || {
      if [[ $n -lt $max ]]; then
        echo "Command failed. Attempt $n/$max..."
        ((n++))
        sleep $delay
      else
        echo "The command has failed after $n attempts."
        return 1
      fi
    }
  done
}

echo "Running apt update..."
retry apt-get update -y

echo "Upgrading packages..."
retry apt-get upgrade -y

echo "Installing Java and Tomcat..."
retry apt-get install -y openjdk-17-jdk tomcat10 tomcat10-admin tomcat10-docs tomcat10-common git

echo "Starting Tomcat..."
systemctl enable tomcat10
systemctl start tomcat10

echo "Checking Tomcat status..."
systemctl status tomcat10 --no-pager

echo "=== USER DATA FINISHED SUCCESSFULLY ==="