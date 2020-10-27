export TOPIC_ID=incoming-topic
export SUBSCRIPTION_ID=incoming-topic-sub

gcloud builds submit . --machine-type=n1-highcpu-8 \
  --config cloud-build-data-generator.yaml \
  --substitutions _TOPIC_ID=${TOPIC_ID}