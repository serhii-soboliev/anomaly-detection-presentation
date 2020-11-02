export JOB_NAME=data-generation-1
export BUCKET_NAME=anomaly-detection-presentation-data
export PROJECT_ID=anomaly-detection-presentation
export IMAGE_NAME=stream-data-generation
export IMAGE_TAG=latest
export TABLE_NAME=anomaly-detection-presentation.work_data_ds.outlier_data
export REGION=us-central1
export SERVICE_ACCOUNT_NAME=dataflow_operator

gcloud beta dataflow flex-template run $JOB_NAME \
--template-file-gcs-location=gs://$BUCKET_NAME/dataflow_templates/stream_data_generation_template.json \
--parameters experiments=disable_flex_template_entrypoint_override \
--parameters staging_location=gs://$BUCKET_NAME/staging \
--parameters temp_location=gs://$BUCKET_NAME/temp \
--parameters output_topic=incoming-topic \
--region=$REGION \
--project=$PROJECT_ID