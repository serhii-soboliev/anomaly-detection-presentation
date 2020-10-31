import logging
import argparse
import apache_beam as beam
from apache_beam.options.pipeline_options import GoogleCloudOptions, PipelineOptions, StandardOptions
from apache_beam.io.external.generate_sequence import GenerateSequence
from apache_beam.io import WriteToPubSub
from apache_beam import ParDo, DoFn


class StreamingDataGenerator:

    def run_generation(args, pipeline_args):
        options = PipelineOptions(pipeline_args, save_main_session=True)
        options.view_as(GoogleCloudOptions)
        options.view_as(StandardOptions).runner = 'DataflowRunner'
        p = beam.Pipeline(options=options)
        start_ = 0
        stop_ = 30
        element_per_period_ = 10
        output_topic = "incoming-topic"

        logging.info("Parameters: start={}, stop={}, elements per second = {}, output topic = {}".format(start_, stop_, element_per_period_, output_topic))
        logging.info("Start generating messages")

        _ = (p | 'Trigger'
             >> GenerateSequence(start=start_, stop=stop_, elements_per_period=element_per_period_)
             | 'GenerateMessages'
             >> ParDo(MessageGeneration())
             | 'WriteToPubSub'
             >> WriteToPubSub(topic=output_topic)
             )

        p.run()

        logging.info("Finish generating messages")


class MessageGeneration(DoFn):

    def to_runner_api_parameter(self, unused_context):
        pass

    def process(self, element, **kwargs):
        output = ','.join(['"' + str(value) + '"' for value in list(element.values())])
        logging.debug("Debug: {}".format(output))
        yield output


if __name__ == '__main__':

    parser = argparse.ArgumentParser()

    parser.add_argument('--input_table_name',
                        type=str,
                        required=True,
                        help='Name of input BigQuery table, in the form PROJECT_ID.DATASET.TABLE')

    parser.add_argument('--output_file_path',
                        type=str,
                        required=True,
                        help='Cloud Storage path to the output CSV file')

    known_args, pipeline_args = parser.parse_known_args()

    # Execute pipeline
    StreamingDataGenerator.run_generation(known_args, pipeline_args)
