import sys
import subprocess
import json


def main():
    Profile = GetArguments()
    print(Profile)

    GetInstancesInfo(Profile)





def GetArguments():
    try:
        return sys.argv[1]
    except:
        return ""


def GetHelp():
    print("""
syntax: 
    
    python3 get_ec2_instances.py NameOfProfile
    
""")



def GetInstancesInfo(Profile):
    if Profile != "":
        Result = subprocess.run(['aws', '--profile', Profile, 'ec2', 'describe-instances'], stdout=subprocess.PIPE)
    else:
        Result = subprocess.run(['aws', 'ec2', 'describe-instances'], stdout=subprocess.PIPE)
    #"aws --profile gamefrk220 ec2 describe-instances"
    print("\n\n")
    Results = Result.stdout.decode('utf-8')
    Results = json.loads(Results)

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
            #print("{}, {}".format(State['Name'], Tags))
            print(Output)

        Counter += 1
    #print(Results)






if __name__ == "__main__":
    print("start")
    main()