#!/bin/bash
n=50

for i in $(seq 1 $n);
do
  printf "Sending Message # %s \n" "$i"
  gcloud pubsub topics publish  projects/anomaly-detection-presentation/topics/incoming-topic --message "{\"subscriber_id\": \"00000000000000000\",  \
  \"audience_interest\": 2222, \
  \"audience_range\": 333}"
done
