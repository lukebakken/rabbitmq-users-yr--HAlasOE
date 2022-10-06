### Resetting MQTT on all nodes

```
for SVC in rmq0 rmq1 rmq2; do docker compose exec "$SVC" rabbitmqctl decommission_mqtt_node "rabbit@$SVC"; done
for SVC in rmq0 rmq1 rmq2; do docker compose exec "$SVC" rabbitmq-plugins disable rabbitmq_mqtt; done
for SVC in rmq0 rmq1 rmq2; do docker compose exec "$SVC" rabbitmq-plugins enable rabbitmq_mqtt; done
```
