<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Project](#about-the-project)
* [Dataflow Diagram](#dataflow-diagram)
* [Outliers visualization](#outliers-visualization)
* [Anomaly detection approach](#anomaly-detection-approach)



<!-- ABOUT THE PROJECT -->
# About the project

This project is built to demonstrate Google Cloud Platform ETL capabilities, 
creating machine learning models to detect anomalies and visualizing obtained results.

<!-- DATAFLOW DIAGRAM -->
# Dataflow diagram
![Dataflow diagram](https://github.com/SergiySobolev/anomaly-detection-presentation/blob/master/images/dataflowdiagram.png)

<!-- OUTLIERS VISUALIZATION -->
# Outliers visualization
![Outliers visualization](https://github.com/SergiySobolev/anomaly-detection-presentation/blob/master/images/visualization.png)

<!-- ANOMALY DETECTION APPROACH -->
# Anomaly Detection approach
Anomalies are detected using [K-Means clustering algorithm](https://towardsdatascience.com/k-means-clustering-algorithm-applications-evaluation-methods-and-drawbacks-aa03e644b48a)
implemented on [BigQuery ML service](https://cloud.google.com/bigquery-ml/docs)
Details could be found there: [BigQuery k-means tutorial](https://cloud.google.com/bigquery-ml/docs/kmeans-tutorial)

