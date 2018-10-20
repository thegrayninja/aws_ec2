# source: https://boto3.amazonaws.com/v1/documentation/api/latest/guide/ec2-example-key-pairs.html
import boto3


def SetEc2():
    ec2 = boto3.client('ec2')


def DescribeKeyPairs(ec2):
    response = ec2.describe_key_pairs()
    print(response)


def CreateKeyPair(ec2):
    KeyPairName = "testing_keys"
    response = ec2.create_key_pair(KeyName=KeyPairName)

    with open(KeyPairName, "w") as PrivateKeyFile:
        PrivateKeyFile.write(response)
    print(response)


def DeleteKeyPair(ec2):
    KeyPairName = "testing_keys"
    response = ec2.delete_key_pair(KeyName=KeyPairName)
    print(response)
