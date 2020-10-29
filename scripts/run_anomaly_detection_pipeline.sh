export DATASET_NAME=work_data_ds
export PROJECT_ID=anomaly-detection-presentation
export SUBSCRIPTION_ID=incoming-topic-sub

gcloud beta dataflow flex-template run "anomaly-detection" \
  --project=${PROJECT_ID} \
  --region=us-central1 \
  --template-file-gcs-location=gs://${DF_TEMPLATE_CONFIG_BUCKET}/dynamic_template_secure_log_aggr_template.json \
  --parameters=autoscalingAlgorithm="NONE",numWorkers=1,maxNumWorkers=1,workerMachineType=n1-standard-2,subscriberId=projects/${PROJECT_ID}/subscriptions/${SUBSCRIPTION_ID},tableSpec=${PROJECT_ID}:${DATASET_NAME}.cluster_model_data,batchFrequency=2,customGcsTempLocation=gs://${DF_TEMPLATE_CONFIG_BUCKET}/temp,tempLocation=gs://${DF_TEMPLATE_CONFIG_BUCKET}/temp,clusterQuery=gs://${DF_TEMPLATE_CONFIG_BUCKET}/normalized_cluster_data.sql,outlierTableSpec=${PROJECT_ID}:${DATASET_NAME}.outlier_data,inputFilePattern=gs://df-ml-anomaly-detection-mock-data/flow_log*.json,workerDiskType=compute.googleapis.com/projects/${PROJECT_ID}/zones/us-central1-b/diskTypes/pd-ssd,diskSizeGb=5,windowInterval=10,writeMethod=FILE_LOADS,streaming=true