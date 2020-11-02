export JOB_NAME="sythetic-data-generator-`date +%Y%m%d-%H%M%S`"
export PROJECT_ID="anomaly-detection-presentation"
export SCHEMA_LOCATION=gs://anomaly-detection-presentation-data/schemas/synthetic_data_schema.json
export PUBSUB_TOPIC="projects/${PROJECT_ID}/topics/incoming-topic"
export REGION=us-east1
export QPS=100

gcloud beta dataflow flex-template run ${JOB_NAME} \
--project=${PROJECT_ID} \
--region=${REGION} \
--template-file-gcs-location=gs://anomaly-detection-presentation-data/dataflow_templates/synthetic_data_generator.json \
--worker-machine-type=n1-standard-1 \
--parameters schemaLocation=${SCHEMA_LOCATION},topic=${PUBSUB_TOPIC},qps=${QPS}