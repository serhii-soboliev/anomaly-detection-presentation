export PROJECT_ID=anomaly-detection-presentation
export IMAGE_NAME=stream-data-generator
export IMAGE_TAG=latest

gcloud builds submit
+t --tag gcr.io/$PROJECT_ID/$IMAGE_NAME:$IMAGE_TAG