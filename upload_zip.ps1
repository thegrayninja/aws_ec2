echo "Importing AWS for PowerShell Module"
#$AWSPowerShellModule = get-childitem -Path "C:\Program Files\AWS Tools\PowerShell\","C:\Program Files (x86)\AWS Tools\PowerShell\" -Include AWSPowerShell.psd1 -recurse -erroraction SilentlyContinue | % {Write-Host $_.FullName}
#echo AWSPowerShellModule

Import-Module "C:\Program Files (x86)\aws tools\powershell\AWSPowerShell\AWSPowerShell.psd1"
echo "done importing AWS for PowerShell Module"
echo ""
echo "Creating a compresed file of folder .\Sessions"

$CurrentHostName = hostname 
$CurrentDate = "{0:yyyy-MM-dd}" -f (get-date)
$FolderPath = ".\Upload\"
$ZipPath = $FolderPath + $CurrentHostName + '_' + $CurrentDate + '.zip'
Compress-Archive ".\Sessions" $ZipPath

echo "Uploading to S3 bucket."
Write-S3Object -BucketName <bucketname> -AccessKey <ak_id> -SecretAccessKey <sak> -File $ZipPath



#$body = "file=$(get-content hostname_date.zip -raw)"
#Invoke-RestMethod -uri http://www.websetite.com/put_file -method POST -body $body

#
