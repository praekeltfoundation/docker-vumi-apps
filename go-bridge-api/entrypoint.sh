#!/usr/bin/env sh
set -e

ACCESS_TOKEN="${ACCESS_TOKEN:-access_token}"
ACCOUNT_KEY="${ACCOUNT_KEY:-account_key}"
CONVERSATION_KEY="${CONVERSATION_KEY:-conversation_key}"
TRANSPORT_NAME="${TRANSPORT_NAME:-transport_name}"
WEB_PATH="${WEB_PATH:-/go-bridge-api}"
BASE_URL="${BASE_URL:-https://go.vumi.org/api/v1/go/http_api_nostream/}"
REDIS_HOST="${REDIS_HOST:-127.0.0.1}"
REDIS_DB="${REDIS_DB:-1}"
REDIS_PORT="${REDIS_PORT:-6379}"
AMQP_HOST="${AMQP_HOST:-127.0.0.1}"
AMQP_PORT="${AMQP_PORT:-5672}"
AMQP_USERNAME="${AMQP_USERNAME:-guest}"
AMQP_PASSWORD="${AMQP_PASSWORD:-guest}"
AMQP_VHOST="${AMQP_VHOST:-/guest}"
AMQP_PREFETCH_COUNT="${AMQP_PREFETCH_COUNT:-20}"


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
