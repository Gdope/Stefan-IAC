#!/bin/bash
set -e

sudo apt update -y
sudo apt install -y memcached

sudo systemctl enable memcached
sudo systemctl start memcached

# Allow external connections (ако ти треба)
sudo sed -i 's/-l 127.0.0.1/-l 0.0.0.0/' /etc/memcached.conf

sudo systemctl restart memcached