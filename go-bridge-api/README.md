# go-bridge-api Docker image
Docker image for [`GoConversationTransport `](https://github.com/praekelt/vumi/blob/develop/vumi/transports/vumi_bridge/vumi_bridge.py)

## Configuration

These variables set parameters for the transport:

* `ACCESS_TOKEN` (defaults to `access_token`)
* `ACCOUNT_KEY` (defaults to `account_key`)
* `CONVERSATION_KEY` (defaults to `conversation_key`)
* `TRANSPORT_NAME` (defaults to `transport_name`)
* `WEB_PATH` (defaults to `/go-bridge-api`)
* `BASE_URL` (defaults to `https://go.vumi.org/api/v1/go/http_api_nostream/`)
* `REDIS_HOST` (defaults to `127.0.0.1`)
* `REDIS_DB` (defaults to `1`)
* `REDIS_PORT` (defaults to `6379`)
* `AMQP_HOST` (defaults to `127.0.0.1`)
* `AMQP_PORT` (defaults to `5672`)
* `AMQP_USERNAME` (defaults to `guest`)
* `AMQP_PASSWORD` (defaults to `guest`)
* `AMQP_VHOST` (defaults to `/guest`)
* `AMQP_PREFETCH_COUNT` (defaults to `20`)
