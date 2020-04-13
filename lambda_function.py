import json
import boto3
import pprint


def lambda_handler(event, context):
    # TODO implement
    s3=boto3.client('s3', region_name='us-east-1')
    file_name="random_key"
    file_obj=s3.get_object(Bucket = "random-buvket", Key = file_name)
    
    file_content=file_obj["Body"].read().decode('utf-8')
#storing the file content in temp file to open as list
    with open("/tmp/tempfile.txt", "w") as f:
    	f.write(str(file_content))
    	
    with open("/tmp/tempfile.txt", "r") as fo:
        random_content= fo.readlines()
    final_out=[]    
    for each_random in random_content:
        for i in range(1,10):
            if str(i) in each_random:
                final_out.append(i)
    final_out=list(dict.fromkeys(final_out))
    print(final_out)
        
        

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }

