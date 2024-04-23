import json
import boto3
import os
s3_client = boto3.client('s3')

def lambda_handler(event, context):
     
    sqs_queue_url = event['Records'][0]['eventSourceARN']
    
     
    s3_bucket_name =  os.environ['S3_BUCKET_NAME']
    
    for record in event['Records']:
         
        message_body = record['body']
        
        try: 
             
            print(message_body)
            dic={"message":message_body}
            mk = json.dumps(dic)
            message_data = json.loads(mk)
            
            
            s3_key = f"{record['messageId']}.json"
            
             
            json_string = json.dumps(message_data)
            
             
            s3_client.put_object(
                Bucket=s3_bucket_name,
                Key=s3_key,
                Body=json_string
            )
            
            print(f"Successfully stored message as JSON object in S3: s3://{s3_bucket_name}/{s3_key}")
        
        except Exception as e:
            print(f"Error processing message: {e}")