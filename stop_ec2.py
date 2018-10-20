import boto3
from botocore.exceptions import ClientError


InstanceID = "i-060109211f50178a6"

ec2 = boto3.client('ec2', region_name='us-west-1')

try:
    ec2.stop_instances(InstanceIds=[InstanceID], DryRun=True)
except ClientError as e:
    if 'DryRunOperation' not in str(e):
        print("You don't have permission to reboot instances.")
        raise

try:
    response = ec2.stop_instances(InstanceIds=[InstanceID], DryRun=False)
    print('Success', response)
except ClientError as e:
    print('Error', e)