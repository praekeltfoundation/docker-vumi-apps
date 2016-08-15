# go-metrics-api Docker image
Docker image for [`go-metrics-api`](https://github.com/praekelt/go-metrics-api)

## Configuration
The path to a config file can be set using the `CONFIG_FILE` environment variable. If this variable is not set, a configuration file will be generated at runtime, with fields populated with the following environment variables.

These which set [`go_api`](https://github.com/praekelt/go-api-toolkit) parameters:
* `URL_PATH_PREFIX`
* `STATIC_OWNER_ID`

These variables set parameters for the Graphite backend:
* `GRAPHITE_URL`
* `GRAPHITE_USERNAME`
* `GRAPHITE_PASSWORD`
* `GRAPHITE_PREFIX`
* `GRAPHITE_DISABLE_AUTO_PREFIX`
* `AMQP_HOST`
* `AMQP_PORT`
* `AMQP_VHOST`
* `AMQP_USERNAME`
* `AMQP_PASSWORD`

At the very least you will probably need a `GRAPHITE_URL`, but none of these parameters are required.
