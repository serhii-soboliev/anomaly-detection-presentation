import logging
import json
import time

import apache_beam as beam
from apache_beam import DoFn
from apache_beam.io import ReadFromPubSub, WriteToBigQuery
from apache_beam.options.pipeline_options import PipelineOptions, SetupOptions


class TransformStorageEventsOptions(PipelineOptions):

    @classmethod
    def _add_argparse_args(cls, parser):
        parser.add_value_provider_argument('--incoming_notification_topic',
                                           type=str,
                                           required=True,
                                           help='Name of topic to get events from')

        parser.add_value_provider_argument('--output_table',
                                           type=str,
                                           required=True,
                                           help='BigQuery table to stream transformed event to')


class TransformStorageEvents(DoFn):

    def to_runner_api_parameter(self, unused_context):
        pass

    def process(self, event, **kwargs):
        logging.info("Initial event: {}".format(event))
        event_json = json.loads(event)
        logging.info("Json event: {}".format(event_json))
        event_json['source'] = "PUBSUB"
        event_json['arrival_time'] = time.time()
        transformed_event = event_json
        logging.info("Transformed event: {}".format(transformed_event))
        yield transformed_event


class ExtractFilename(DoFn):

    def to_runner_api_parameter(self, unused_context):
        pass

    def process(self, notification, **kwargs):
        logging.info("Notification: {}".format(notification))
        file_name = 'gs://{}/{}'.format(notification['bucket'], notification['name'])
        logging.info("Filename: {}".format(file_name))
        yield file_name


def run():
    transform_storage_events_options = PipelineOptions().view_as(TransformStorageEventsOptions)
    pipeline_options = PipelineOptions()
    pipeline_options.view_as(SetupOptions).save_main_session = True
    p = beam.Pipeline(options=pipeline_options, )
    incoming_notification_topic = str(transform_storage_events_options.incoming_notification_topic)
    logging.info("Notification topic = {}".format(incoming_notification_topic))
    output_table = str(transform_storage_events_options.output_table)
    logging.info("Output table for files: {}".format(output_table))

    _ = (p
         | 'Notification from pubsub' >> ReadFromPubSub(incoming_notification_topic)
         | "Convert notification to dict" >> beam.Map(lambda x: json.loads(x))
         | "Extract filename" >> beam.ParDo(ExtractFilename())
         )
         # | "read file" >> ReadAllFromText() \
         # | 'split' >> beam.Map(lambda x: x.split(',')) \
         # | 'format to dict' >> beam.Map(lambda x: {"id": x[0], "name": x[1]})

    p.run()


if __name__ == '__main__':
    logging.getLogger().setLevel(logging.INFO)
    run()
