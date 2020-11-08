import logging
import json
import time

import apache_beam as beam
from apache_beam.io import ReadStringsFromPubSub, WriteToBigQuery
from apache_beam.options.pipeline_options import PipelineOptions, SetupOptions


class TransformEventsOptions(PipelineOptions):

    @classmethod
    def _add_argparse_args(cls, parser):
        parser.add_value_provider_argument('--incoming_topic',
                                           type=str,
                                           required=True,
                                           help='Name of topic to get events from')

        parser.add_value_provider_argument('--output_table',
                                           type=str,
                                           required=True,
                                           help='BigQuery table to stream transformed event to')


class TransformEvents(beam.DoFn):

    def to_runner_api_parameter(self, unused_context):
        pass

    def process(self, event):
        logging.info("Initial event: {}".format(event))
        event_json = json.loads(event)
        logging.info("Json event: {}".format(event_json))
        event_json['source'] = "PUBSUB"
        event_json['arrival_time'] = time.time()
        transformed_event = event_json
        logging.info("Transformed event: {}".format(transformed_event))
        yield transformed_event


def run():
    transform_events_options = PipelineOptions().view_as(TransformEventsOptions)
    pipeline_options = PipelineOptions()
    pipeline_options.view_as(SetupOptions).save_main_session = True
    p = beam.Pipeline(options=pipeline_options, )
    incoming_topic = str(transform_events_options.incoming_topic)
    logging.info("Incoming topic for events = {}".format(incoming_topic))
    output_table = str(transform_events_options.output_table)
    logging.info("Output table for transformed events: {}".format(output_table))

    _ = (p
         | 'Read events from PubSub' >> ReadStringsFromPubSub(incoming_topic)
         | 'Transform PubSub events' >> beam.ParDo(TransformEvents())
         | 'Write to BigQuery' >> WriteToBigQuery(table=output_table)
         )

    p.run()


if __name__ == '__main__':
    logging.getLogger().setLevel(logging.DEBUG)
    run()
