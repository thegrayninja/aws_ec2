# source: https://boto3.amazonaws.com/v1/documentation/api/latest/guide/ec2-example-managing-instances.html
import boto3

def main():
    State = DescribeEC2Instances()
    print(State)


def DescribeEC2Instances():
    ec2 = boto3.client('ec2', region_name='us-west-1')
    Results = ec2.describe_instances()
    Output = "State, PublicDnsName, InstanceId"

    Counter = 0
    for i in Results["Reservations"]:
        State = Results["Reservations"][Counter]["Instances"][0]["State"]
        Tags = Results["Reservations"][Counter]["Instances"][0]["Tags"]
        InstanceID = Results["Reservations"][Counter]["Instances"][0]["InstanceId"]
        PublicDnsName = Results["Reservations"][Counter]["Instances"][0]["PublicDnsName"]

        if State['Name'] == 'running' or 'stop' in State['Name']:
            Output += "\n{}, {}, {}".format(State['Name'], PublicDnsName, InstanceID)
            for i in Tags:
                Output += ", {}: {}".format(i['Key'], i['Value'])
            # print("{}, {}".format(State['Name'], Tags))
            Counter += 1


    return Output


if __name__ == '__main__':
    print("starting")
    main()