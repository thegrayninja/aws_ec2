import requests

import xml.etree.ElementTree as etree
import os
import subprocess
import json



def main():

    BucketList = OpenBucketList()
    CheckPublicStatus(BucketList)
    #AccessBucketURL(BucketList)
    #AccessBucketAWSCLI(BucketList)


def OpenBucketList():
    with open("bucket_list.txt", "r") as BucketFile:
        Buckets = BucketFile.readlines()

    return Buckets


def CheckPublicStatus(Buckets):
    URLResults = {}
    AWSResults = {}
    for i in Buckets:
        Bucket = i.strip()
        URLStatus = AccessBucketURL(Bucket)
        AWSCLIStatus = AccessBucketAWSCLI(Bucket)

        URLResults[Bucket] = URLStatus
        AWSResults[Bucket] = AWSCLIStatus

    print("URL Status: \n")
    for key, value in URLResults.items():
        print(key, value)
    print("\n\nAWS CLI Status: \n:")
    for key, value in AWSResults.items():
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
    Profile = "backup"
    Command = ['aws', '--profile', '{}'.format(Profile), 's3api', 'list-objects', '--bucket', '{}'.format(Bucket)]#.format(Profile, Bucket)

    Result = subprocess.Popen(Command, stdout=subprocess.PIPE)
    Output = Result.stdout.read().decode("utf-8")
    print(Output)
    try:
        if Output[0] == "{":
            return "Open"
        else:
            return "Access Denied"
    except:
        return "Access Denied"


if __name__ == main():
    main()
