export PROJECT_ID=anomaly-detection-presentation
export IMAGE_NAME=anomaly-detection
export IMAGE_TAG=1.0

gcloud builds submit --tag gcr.io/$PROJECT_ID/$IMAGE_NAME:$IMAGE_TAG