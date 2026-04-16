#!/bin/bash
set -e

sudo apt update -y

# install rabbitmq
sudo apt install -y rabbitmq-server

# enable & start
sudo systemctl enable rabbitmq-server
sudo systemctl start rabbitmq-server

# enable management UI (optional ali preporuka)
sudo rabbitmq-plugins enable rabbitmq_management

# allow remote access (disable loopback restriction)
echo '[{rabbit, [{loopback_users, []}]}].' | sudo tee /etc/rabbitmq/rabbitmq.config

# create user
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
sudo rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

# restart
sudo systemctl restart rabbitmq-server