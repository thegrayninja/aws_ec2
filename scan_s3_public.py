import requests

import xml.etree.ElementTree as etree
import os
import subprocess
import json



def main():

    BucketList = OpenBucketList()
    CheckPublicStatus(BucketList)


def OpenBucketList():
    with open("list_of_buckets.txt", "r") as BucketFile:
        Buckets = BucketFile.readlines()

    return Buckets


def CheckPublicStatus(Buckets):
    URLResults = {}
    AWSResults = {}
    AWSUploadResults = {}
    for i in Buckets:
        Bucket = i.strip()
        URLStatus = AccessBucketURL(Bucket)
        AWSCLIStatus = AccessBucketAWSCLI(Bucket)
        AWSUploadStatus = AttemptToSave(Bucket)

        URLResults[Bucket] = URLStatus
        AWSResults[Bucket] = AWSCLIStatus
        AWSUploadResults[Bucket] = AWSUploadStatus

    print("URL Status: \n")
    for key, value in URLResults.items():
        if value == "Open":
            print(key, value)

    print("\n\nAWS CLI Status: \n:")
    for key, value in AWSResults.items():
        if value == "Open":
            print(key, value)

    print("\n\nAWS CLI Upload Status: \n:")
    for key, value in AWSUploadResults.items():
        if value == "Open":
            print(key, value)



def AccessBucketURL(Bucket):
        URL = "http://{}.s3.amazonaws.com".format(Bucket)
        Response = requests.get(URL)

        try:
            return(GetXMLIfValid(Bucket, Response))

        except:
            return("Open")
            #return(GetPageContentIfValid(Bucket, Response))




def GetXMLIfValid(Bucket, Response):
    tree = etree.fromstring(Response.content)
    node = tree.find('Message')
    print("{} - {} - {}".format(Bucket, tree.tag, node.text))
    return(node.text)



def GetPageContentIfValid(Bucket, Response):
    print("{} - success?".format(Bucket))
    return "success"



def AccessBucketAWSCLI(Bucket):
    Profile = "dev"
    Command = ['aws', '--profile', '{}'.format(Profile), 's3api', 'list-objects', '--bucket', '{}'.format(Bucket)]#.format(Profile, Bucket)

    Result = subprocess.Popen(Command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    Output = Result.stdout.read().decode("utf-8")
    print(Output)
    try:
        if Output[0] == "{":
            return "Open"
        else:
            return "Access Denied"
    except:
        return "Access Denied"


def AttemptToSave(Bucket):
    Profile = "dev"
    Command = ['aws', '--profile', '{}'.format(Profile), 's3', 'cp', '.\\test123abc.txt', 's3://{}/'.format(Bucket)]

    Result = subprocess.Popen(Command, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    Output = Result.stdout.read().decode("utf-8")
    print(Output)
    try:
        if "failed" in Output:
            print("upload failed")
            return "Access Denied"
        else:
            return "Open"
    except:
        return "Open"


if __name__ == main():
    main()
