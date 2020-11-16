from google.cloud import pubsub_v1
import logging
import json
import random


def build_message():
    subscriber_id = "000001"
    audience_interest = random.randint(1000, 5000)
    audience_range = random.randint(100, 500)
    data = {"subscriber_id": subscriber_id, "audience_interest": audience_interest, "audience_range": audience_range}
    return json.dumps(data).encode("utf-8")


def send_synthetic_events(message_count):
    publisher = pubsub_v1.PublisherClient()
    topic_id = "incoming-topic"
    project_id = "anomaly-detection-presentation"
    topic_path = publisher.topic_path(project_id, topic_id)

    for n in range(1, message_count):
        message = build_message()
        future = publisher.publish(topic_path, message)
        print(future.result())


if __name__ == '__main__':
    logging.getLogger().setLevel(logging.INFO)
    message_count = 25
    send_synthetic_events(message_count)