export BUCKET_NAME=anomaly-detection-presentation-data
export PROJECT_ID=anomaly-detection-presentation
export IMAGE_NAME=stream-data-generation
export IMAGE_TAG=latest

gcloud beta dataflow flex-template build gs://$BUCKET_NAME/dataflow_templates/stream_data_generation_template.json \
--image=gcr.io/$PROJECT_ID/$IMAGE_NAME:$IMAGE_TAG \
--sdk-language=PYTHON \
--metadata-file=stream_data_generation_metadata.json
