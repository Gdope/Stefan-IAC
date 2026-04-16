#!/bin/bash
set -e
sudo apt update
sudo apt upgrade -y
sudo apt install openjdk-17-jdk -y
sudo apt install tomcat10 tomcat10-admin tomcat10-docs tomcat10-common git -y
sudo systemctl start tomcat10
sudo systemctl enable tomcat10

