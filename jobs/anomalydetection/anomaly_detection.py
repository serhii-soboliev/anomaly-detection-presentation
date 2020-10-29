import logging
import argparse
import apache_beam as beam
from apache_beam.options.pipeline_options import GoogleCloudOptions, PipelineOptions, StandardOptions


class AnomalyDetection(beam.DoFn):

    def to_runner_api_parameter(self, unused_context):
        pass

    def process(self, element, **kwargs):
        output = ','.join(['"' + str(value) + '"' for value in list(element.values())])
        logging.debug("Debug: {}".format(output))
        yield output


def run_pipeline(args, pipeline_args):
    options = PipelineOptions(pipeline_args, save_main_session=True)
    options.view_as(GoogleCloudOptions)
    options.view_as(StandardOptions).runner = 'DataflowRunner'
    p = beam.Pipeline(options=options)

# Define table query
    query = 'SELECT * FROM `{input_table_name}`'.format(input_table_name=args.input_table_name)

    # Define pipeline steps
    _ = (p | 'ReadFromBigQuery_'
         >> beam.io.Read(beam.io.BigQuerySource(query=query, use_standard_sql=True))
         | 'ConvertToCSV_'
         >> beam.ParDo(AnomalyDetection())
         | 'WriteToStorage_'
         >> beam.io.WriteToText(file_path_prefix=args.output_file_path, file_name_suffix='.csv')
         )

    p.run()

if __name__ == '__main__':

# Get the pipeline arguments
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
    run_pipeline(known_args, pipeline_args)
