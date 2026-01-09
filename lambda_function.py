import json
import boto3

# Connect to DynamoDB
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('media_metadata')

def lambda_handler(event, context):
    # Loop through each S3 event record
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = record['s3']['object']['key']
        size = record['s3']['object']['size']

        # Store metadata in DynamoDB
        table.put_item(
            Item={
                'file_name': key,
                'bucket_name': bucket,
                'file_size': size
            }
        )

    return {
        'statusCode': 200,
        'body': json.dumps('Metadata stored successfully!')
    }