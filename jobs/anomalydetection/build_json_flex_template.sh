export BUCKET_NAME=anomaly-detection-presentation-data
export PROJECT_ID=anomaly-detection-presentation
export IMAGE_NAME=anomaly-detection
export IMAGE_TAG=1.0

gcloud beta dataflow flex-template build gs://$BUCKET_NAME/dataflow_templates/anomaly_detection_template.json \
--image=gcr.io/$PROJECT_ID/$IMAGE_NAME:$IMAGE_TAG \
--sdk-language=PYTHON \
--metadata-file=anomaly_detection_pipeline_metadata.json
