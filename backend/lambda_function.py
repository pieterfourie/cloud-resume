import os
import json
import boto3
from botocore.exceptions import ClientError

dynamodb = boto3.client("dynamodb")
TABLE_NAME  = os.getenv("TABLE_NAME")
PRIMARY_KEY = os.getenv("PRIMARY_KEY", "id")
KEY_VALUE   = os.getenv("KEY_VALUE", "site_visits")
ALLOW_ORIGIN = os.getenv("ALLOW_ORIGIN", "*")

def _headers():
    return {
        "Content-Type": "application/json",
        "Access-Control-Allow-Origin": ALLOW_ORIGIN,
        "Access-Control-Allow-Methods": "GET,OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type"
    }

def lambda_handler(event, context):
    if event.get("requestContext", {}).get("http", {}).get("method") == "OPTIONS":
        return { "statusCode": 204, "headers": _headers(), "body": "" }

    try:
        resp = dynamodb.update_item(
            TableName=TABLE_NAME,
            Key={ PRIMARY_KEY: {"S": KEY_VALUE} },
            UpdateExpression="SET #c = if_not_exists(#c, :zero) + :one",
            ExpressionAttributeNames={ "#c": "count" },
            ExpressionAttributeValues={ ":zero": {"N": "0"}, ":one": {"N": "1"} },
            ReturnValues="UPDATED_NEW"
        )
        visits = int(resp["Attributes"]["count"]["N"])
        body = {"visits": visits}
        status = 200
    except ClientError as e:
        body = {"error": str(e)}
        status = 500

    return { "statusCode": status, "headers": _headers(), "body": json.dumps(body) }
