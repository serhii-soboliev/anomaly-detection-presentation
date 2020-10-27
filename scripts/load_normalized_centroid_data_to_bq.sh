export PROJECT_ID=anomaly-detection-presentation
export DATASET_NAME=work_data_ds
bq load \
  --source_format=NEWLINE_DELIMITED_JSON \
  ${PROJECT_ID}:${DATASET_NAME}.normalized_centroid_data \
  gs://anomaly-detection-presentation-data/normalized_centroid_data.json \
  schemas/normalized_centroid_data_schema.json