import boto3
import json


def lambda_handler(event, context):
    print("Lambda Function Name: ", context.function_name)
    print("Event is: ", event)
    number1 = event["number1"]
    number2 = event["number2"]

    result = number1 + number2

    print("Sum:", result)

    return {"statusCode": 200, "body": json.dumps({"result": result})}
