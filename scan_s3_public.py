import requests

import xml.etree.ElementTree as etree
import os
import subprocess
import json



def main():

    BucketList = OpenBucketList()
    #AccessBucketURL(BucketList)
    AccessBucketAWSCLI(BucketList)


def OpenBucketList():
    with open("bucket_list.txt", "r") as BucketFile:
        Buckets = BucketFile.readlines()

    return Buckets


def AccessBucketURL(Buckets):

    for i in Buckets:
        Bucket = i.strip()
        #print(Bucket)
        URL = "http://{}.s3.amazonaws.com".format(Bucket)

        Response = requests.get(URL)
        try:
            GetXMLIfValid(Bucket, Response)
        except:
            GetPageContentIfValid(Bucket, Response)


def GetXMLIfValid(Bucket, Response):
    tree = etree.fromstring(Response.content)
    node = tree.find('Message')
    print("{} - {} - {}".format(Bucket, tree.tag, node.text))



def GetPageContentIfValid(Bucket, Response):
    print("{} - success?".format(Bucket))



def AccessBucketAWSCLI(Buckets):
    Success = []
    Failure = []
    Commands = []
    for i in Buckets:
        Bucket = i.strip()
        Profile = "backup"
        Command = ['aws', '--profile', '{}'.format(Profile), 's3api', 'list-objects', '--bucket', '{}'.format(Bucket)]#.format(Profile, Bucket)

        Result = subprocess.Popen(Command, stdout=subprocess.PIPE)
        Output = Result.stdout.read().decode("utf-8")
        print(Output)
        try:
            if Output[0] == "{":
                Success.append(Bucket)
        except:

            Failure.append(Bucket)
        Commands.append(Bucket)

    print("\n\n\n")
    print("Successful Attempts - Open Access:")
    print(Success)
    print("Failed Attempts - Access Denied:")
    print(Failure)


if __name__ == main():
    main()
