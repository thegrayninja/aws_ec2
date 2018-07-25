import requests

import xml.etree.ElementTree as etree



def main():

    OpenBucketList()



def OpenBucketList():
    with open("bucket_list.txt", "r") as BucketFile:
        Buckets = BucketFile.readlines()

    AccessBucketURL(Buckets)
    return 0


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
    #print(node.text)
    # print(URLStatus.xpath('//Error'))


def GetPageContentIfValid(Bucket, Response):
    print("{} - success?".format(Bucket))


if __name__ == main():
    main()
