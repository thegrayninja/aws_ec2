import json
import os
import time
import sys


def main():
    try:
        RouteChoice(sys.argv[1])
    except:
        GetHelp()

    return 0


def RouteChoice(Choice):
    InstanceID = "<instance_id>"
    if Choice.lower() == "--start":
        StartInstance(InstanceID)
    elif Choice.lower() == "--stop":
        StopInstance(InstanceID)
    elif Choice.lower() == "--status":
        GetStatusInstance(InstanceID)
    else:
        GetHelp()


def StartInstance(InstanceID):
    AWSGetStatus = "aws --profile backup ec2 start-instances --instance-ids {}".format(InstanceID)
    os.system(AWSGetStatus)

    print("Waiting 15 seconds for asset initialization")
    time.sleep(15)

    AWSGetStatus = "aws --profile backup ec2 describe-instances --instance-ids {} > aws_asset_info.json".format(InstanceID)
    os.system(AWSGetStatus)

    data = json.load(open('aws_asset_info.json'))
    PublicIP = data["Reservations"][0]["Instances"][0]["PublicIpAddress"]
    print("\n\nPublic IP: %s" % PublicIP)

    input("\nAsset booting up")
    return 0


def StopInstance(InstanceID):
    PowerOffAsset = "aws --profile backup ec2 stop-instances --instance-ids {}".format(InstanceID)
    os.system(PowerOffAsset)

    input("\nAsset powering off")



def GetStatusInstance(InstanceID):
    AWSGetStatus = "aws --profile backup ec2 describe-instances --instance-ids {} > aws_asset_info.json".format(InstanceID)
    os.system(AWSGetStatus)

    data = json.load(open('aws_asset_info.json'))
    Status = data["Reservations"][0]["Instances"][0]["Monitoring"]["State"]
    try:
        HostName = data["Reservations"][0]["Instances"][0]["Tags"][0]["Value"]
    except:
        HostName = "<none>"
    try:
        PrivateIP = data["Reservations"][0]["Instances"][0]["PrivateIpAddress"]
    except:
        PrivateIP = "0.0.0.0"
    try:
        PublicIP = data["Reservations"][0]["Instances"][0]["PublicIpAddress"]
    except:
        PublicIP = "0.0.0.0"
    print("\n\nHostname: {}\nStatus: {}\nPrivate IP: {}\nPublic IP: {}\n".format(HostName, Status, PrivateIP, PublicIP))
    return 0


def GetHelp():
    Examples = """

Examples:
    python3 ec2_instance.py --start
    python3 ec2_instance.py --stop
    python3 ec2_instance.py --status
    
    
    """
    print(Examples)
    return 0

if __name__ == main():
    main()
