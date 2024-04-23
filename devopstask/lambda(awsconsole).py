import json
import boto3
import os
s3_client = boto3.client('s3')
def lambda_handler(event, context):
    for record in event['Records']:
        sqs_message_body = record['body']
        try:
            print(sqs_message_body)
            message_data = json.loads(sqs_message_body)
            json_string = json.dumps(message_data)
            print(json_string)
            print(type(sqs_message_body))
            s3_bucket_name = os.environ['S3_BUCKET_NAME']
            s3_key = f'{message_data["id"]}.json'   
            response = s3_client.put_object(
                Body=sqs_message_body,
                Bucket= s3_bucket_name,
                Key=s3_key
            )
            
            print(f"File uploaded successfully to S3: s3://{s3_bucket_name}/{s3_key}")
        
        except Exception as e:
            print(f"Error processing message: {e}")