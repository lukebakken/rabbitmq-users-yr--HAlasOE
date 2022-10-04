#!/usr/bin/env bash

set -o xtrace
set -o errexit
set -o nounset
set -o pipefail

docker compose exec rmq0 rabbitmqctl stop_app

for SVC in rmq1 rmq2
do
    set +o errexit
    # Note: this command may fail if the node is already forgotten
    docker compose exec "$SVC" rabbitmqctl forget_cluster_node rabbit@rmq0
    set -o errexit

    # docker compose exec "$SVC" rabbitmqctl stop_app
    docker compose stop "$SVC"

    # Completely comment out cluster formation with rmq0
    # for the rmq1 and rmq2 nodes configuration
    sed -i.bak -e '/rmq0/s/^/# /' "$SVC.conf"

    # docker compose exec "$SVC" rabbitmqctl start_app
    docker compose start "$SVC"

    sleep 1
    docker compose exec "$SVC" rabbitmqctl await_startup
done

echo ABOUT TO RESET AND START RMQ0, ANY KEY TO CONTINUE
read

# Completely comment out cluster formation for rmq0
sed -i.bak -e '/^cluster_formation/s/^/# /' rmq0.conf
docker compose exec rmq0 rabbitmqctl reset
docker compose exec rmq0 rabbitmqctl start_app
