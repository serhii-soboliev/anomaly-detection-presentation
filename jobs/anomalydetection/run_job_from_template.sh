export JOB_NAME=anomaly-detection-job-2
export BUCKET_NAME=anomaly-detection-presentation-data
export PROJECT_ID=anomaly-detection-presentation
export IMAGE_NAME=anomaly-detection
export IMAGE_TAG=1.0
export TABLE_NAME=anomaly-detection-presentation.work_data_ds.outlier_data
export REGION=us-central1
export SERVICE_ACCOUNT_NAME=dataflow_operator

gcloud beta dataflow flex-template run $JOB_NAME \
--template-file-gcs-location=gs://$BUCKET_NAME/dataflow_templates/anomaly_detection_template.json \
--parameters input_table_name=$TABLE_NAME \
--parameters output_file_path=gs://$BUCKET_NAME/output \
--parameters experiments=disable_flex_template_entrypoint_overrride \
--parameters staging_location=gs://$BUCKET_NAME/staging \
--parameters temp_location=gs://$BUCKET_NAME/temp \
--region=$REGION \
--project=$PROJECT_ID