import logging

from jobs.readfilesfromgcs.upload_files_to_bucket import upload_files_to_bucket

if __name__ == '__main__':
    logging.getLogger().setLevel(logging.INFO)
    upload_files_to_bucket("eventfiles")