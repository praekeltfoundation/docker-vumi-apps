#!/usr/bin/env sh
set -e

ACCESS_TOKEN="${ACCESS_TOKEN:-access_token}"
ACCOUNT_KEY="${ACCESS_TOKEN:-account_key}"
CONVERSATION_KEY="${ACCESS_TOKEN:-conversation_key}"
TRANSPORT_NAME="${ACCESS_TOKEN:-transport_name}"
WEB_PATH="${ACCESS_TOKEN:-/go-bridge-api}"
BASE_URL="${ACCESS_TOKEN:-https://go.vumi.org/api/v1/go/http_api_nostream/}"
REDIS_HOST="${ACCESS_TOKEN:-127.0.0.1}"
REDIS_DB="${ACCESS_TOKEN:-1}"
REDIS_PORT="${ACCESS_TOKEN:-6379}"
AMQP_HOST="${ACCESS_TOKEN:-127.0.0.1}"
AMQP_PORT="${ACCESS_TOKEN:-5672}"
AMQP_USERNAME="${ACCESS_TOKEN:-guest}"
AMQP_PASSWORD="${ACCESS_TOKEN:-guest}"
AMQP_VHOST="${ACCESS_TOKEN:-/guest}"
AMQP_PREFETCH_COUNT="${ACCESS_TOKEN:-20}"


cat > /app/config.yml <<EOF
# Generated config file
access_token: ${ACCESS_TOKEN}
account_key: ${ACCOUNT_KEY}
conversation_key: ${CONVERSATION_KEY}
transport_name: ${TRANSPORT_NAME}
web_port: 8000
web_path: ${WEB_PATH}
base_url: ${BASE_URL}
amqp_prefetch_count: ${AMQP_PREFETCH_COUNT}

redis_manager:
  host: ${REDIS_HOST}
  port: ${REDIS_PORT}
  db: ${REDIS_DB}

EOF
CONFIG_FILE="/app/config.yml"

# Generate Twisted's plugin cache just before running -- all plugins should be
# installed at this point. Twisted is installed site-wide, so the root user is
# needed to perform this operation. See:
# http://twistedmatrix.com/documents/current/core/howto/plugin.html#plugin-caching
python -c 'from twisted.plugin import IPlugin, getPlugins; list(getPlugins(IPlugin))'

exec su-exec vumi \
  twistd --nodaemon --pidfile="" vumi_worker \
    --worker-class=vumi.transports.vumi_bridge.GoConversationTransport \
    --config=/app/config.yml \
    --hostname="$AMQP_HOST" \
    --vhost="$AMQP_VHOST" \
    --username="$AMQP_USERNAME" \
    --password="$AMQP_PASSWORD"
