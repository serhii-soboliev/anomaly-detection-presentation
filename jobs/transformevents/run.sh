pip install apache_beam

export PROJECT=anomaly-detection-presentation
export REGION=us-central1
export BUCKET=gs://anomaly-detection-presentation-data
export DATASET_NAME=work_ds
export TABLE_NAME=audience_events_data
export TOPIC_NAME=incoming-topic

python3 transform_events_job.py \
--region $REGION \
--runner DataflowRunner \
--project $PROJECT \
--job_name transform-events-job \
--temp_location gs://$BUCKET/tmp/ \
--incoming_topic=projects/$PROJECT/topics/$TOPIC_NAME \
--output_table=$PROJECT:$DATASET_NAME.$TABLE_NAME \
--streaming

