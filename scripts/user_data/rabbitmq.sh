#!/bin/bash
set -e

exec > /var/log/user-data.log 2>&1

echo "=== RABBITMQ USER DATA START ==="

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
        echo "Command failed after $n attempts."
        return 1
      fi
    }
  done
}

echo "Updating packages..."
retry apt-get update -y

echo "Installing RabbitMQ..."
retry apt-get install -y rabbitmq-server

echo "Enabling and starting RabbitMQ..."
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

echo "Enabling management plugin..."
rabbitmq-plugins enable rabbitmq_management

echo "Allowing remote access..."
cat > /etc/rabbitmq/rabbitmq.config <<'EOF'
[{rabbit, [{loopback_users, []}]}].
EOF

echo "Restarting RabbitMQ..."
systemctl restart rabbitmq-server

echo "Creating admin user..."
rabbitmqctl add_user test test || true
rabbitmqctl set_user_tags test administrator
rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

echo "Checking RabbitMQ status..."
systemctl status rabbitmq-server --no-pager

echo "=== RABBITMQ USER DATA FINISHED SUCCESSFULLY ==="