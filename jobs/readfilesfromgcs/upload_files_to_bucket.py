from google.cloud import storage
from os import listdir
from os.path import isfile, join
import logging

def upload_files_to_bucket(path_to_folder):
    bucket_name = "anomaly-detection-presentation-data"
    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket_name)
    event_files = [f for f in listdir(path_to_folder) if isfile(join(path_to_folder, f))]
    for event_file in event_files:
        path_to_file = join(path_to_folder, event_file)
        path_to_blob = "incoming/{}".format(event_file)
        blob = bucket.blob(path_to_blob)
        blob.upload_from_filename(path_to_file)
        logging.info("File {} uploaded to {}".format(path_to_file, path_to_blob))

