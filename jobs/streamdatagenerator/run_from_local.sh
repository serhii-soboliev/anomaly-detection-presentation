export PROJECT=anomaly-detection-presentation
export REGION=us-central1
export BUCKET=gs://anomaly-detection-presentation-data
python3 streaming_data_generator.py \
--region $REGION \
--runner DataflowRunner \
--project $PROJECT \
--job_name generate-data \
--temp_location gs://$BUCKET/tmp/ \
--incoming-topic=projects/$PROJECT/topics/incoming-topic \
--streaming

