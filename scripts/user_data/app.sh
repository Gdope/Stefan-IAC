#!/bin/bash
set -e

exec > /var/log/user-data.log 2>&1

echo "=== USER DATA START ==="

echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4

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

echo "Updating packages..."
retry apt-get update -y

echo "Installing Java, curl and unzip..."
retry apt-get install -y openjdk-17-jdk curl unzip

echo "Creating tomcat user..."
useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat || true

cd /tmp

echo "Downloading Tomcat..."
retry curl -fL -o apache-tomcat-10.1.54.tar.gz https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.54/bin/apache-tomcat-10.1.54.tar.gz

echo "Installing Tomcat..."
mkdir -p /opt/tomcat
tar -xzf apache-tomcat-10.1.54.tar.gz -C /opt/tomcat --strip-components=1

chown -R tomcat:tomcat /opt/tomcat
chmod -R u+x /opt/tomcat/bin

echo "Creating Tomcat systemd service..."
cat > /etc/systemd/system/tomcat.service <<'EOF'
[Unit]
Description=Apache Tomcat 10
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat
Environment=JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "Starting Tomcat..."
systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat
systemctl status tomcat --no-pager

echo "Installing AWS CLI v2..."

cd /tmp
retry curl -fL -o awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
unzip -o awscliv2.zip
./aws/install

aws --version

echo "AWS CLI installed successfully"

echo "=== USER DATA FINISHED SUCCESSFULLY ==="