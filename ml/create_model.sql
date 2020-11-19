CREATE OR REPLACE MODEL
  work_ds.audience_events_outliers
OPTIONS
  (model_type='kmeans',
   num_clusters=1,
   standardize_features = TRUE) AS
SELECT
  DISTINCT
  audience_interest,
  audience_range
FROM
  `anomaly-detection-presentation.work_ds.audience_events_data`