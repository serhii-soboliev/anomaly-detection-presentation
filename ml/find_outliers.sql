WITH
  Distances AS (
  SELECT
    DISTINCT ML.CENTROID_ID,
    audience_range,
    audience_interest,
    MIN(NEAREST_CENTROIDS_DISTANCE.DISTANCE) AS distance_from_closest_centroid
  FROM
    ML.PREDICT(MODEL work_ds.audience_events_outliers_model,
      (
      SELECT
        DISTINCT
        audience_range,
        audience_interest
      FROM
        `anomaly-detection-presentation.work_ds.audience_events_data` )) AS ML
  CROSS JOIN
    UNNEST(NEAREST_CENTROIDS_DISTANCE) AS NEAREST_CENTROIDS_DISTANCE
  GROUP BY
    ML.CENTROID_ID,
    audience_range,
    audience_interest ),


  Threshold AS (
  SELECT
    ROUND(APPROX_QUANTILES(distance_from_closest_centroid,10000)[
    OFFSET
      (9500)],2) AS threshold
  FROM
    Distances)

SELECT d.*
FROM Distances d
         JOIN
     Threshold
     ON
         d.distance_from_closest_centroid > Threshold.threshold
