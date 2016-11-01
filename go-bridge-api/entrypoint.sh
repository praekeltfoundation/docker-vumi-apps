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
export CONFIG_FILE="/app/config.yml"
export WORKER_CLASS="vumi.transports.vumi_bridge.GoConversationTransport"

exec vumi-entrypoint.sh
