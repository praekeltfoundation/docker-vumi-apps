#!/usr/bin/env bash
set -e

# Make sure the container can start and connect to RabbitMQ
IMAGE_TAG="praekeltfoundation/go-bridge-api"

CONTAINERS=()
function docker_run {
  # Run a detached container temporarily for tests. Removes the container when
  # the script exits and sleeps a bit to wait for it to start.
  local container
  container="$(docker run -d "$@")"
  echo "$container"
  CONTAINERS+=("$container")
  sleep 5
}

function remove_containers {
  echo "Stopping and removing containers..."
  for container in "${CONTAINERS[@]}"; do
    docker stop "$container"
    docker rm "$container"
  done
}
trap remove_containers EXIT

echo "Launching RabbitMQ container..."
docker_run --name vumi-rabbitmq rabbitmq

echo "Launching go-bridge-api container..."
docker_run --name go-bridge-api --link vumi-rabbitmq:rabbitmq -p 8000:8000 \
  -e AMQP_HOST=rabbitmq \
  "$IMAGE_TAG"

function try_a_few_times {
  # Stolen from http://unix.stackexchange.com/a/137639 with a few adjustments
  local n=1 max=5 delay=2
  until "$@"; do
    if [[ "$n" < "$max" ]]; then
      ((n++))
      echo "Command failed. Trying again ($n/$max)..."
      sleep $delay
    else
      fail "The command has failed after $n attempts."
    fi
  done
}

function check_bridge_api_logs {
  echo "Checking container logs to see if it started correctly..."
  docker logs go-bridge-api | fgrep 'Starting a GoConversationTransport worker'
  docker logs go-bridge-api | fgrep 'Got an authenticated connection'
}
try_a_few_times check_bridge_api_logs

echo
echo "Done"
