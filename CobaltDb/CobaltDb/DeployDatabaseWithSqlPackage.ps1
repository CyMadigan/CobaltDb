param ([string] $Option,[string] $location)

#it's really easy to select the action you want as we can output the files created using the new parameters 
#     DeployScriptPath
#     DeployReportPath
#enter either "publish" or "script"
$Option = "publish"

#set to either local or azure and update the $sqlconnection accordingly
$location = "azure"

#assumes you have downloaded 16.5 for Visual Studio 2015. 2013 will need to go to "13.0"
$sqlpackage = "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\Extensions\Microsoft\SQLDB\DAC\130\sqlpackage.exe"

#validate the $option for action parameter
if (-not ($Option -match "Publish" -or ( $Option -match "Script")))
{
Throw 'You must enter either "Publish" or "Script" in $option to continue'
}
$a = "/Action:$Option"

#validate whether azure or local and set connection string accordingly
if (-not ($location -match "azure" -or ( $location -match "local")))
{
Throw 'You must enter either "azure" or "local" in $location to continue'
}
if ($location -eq "azure")
{
	#intentionally left blank; you need to provide connection string to your sql azure instance
$sqlconnection = ""
}
else
{
$sqlconnection = "SERVER=.; Integrated Security=True"
}

$tcs = "/TargetConnectionString:$sqlconnection"
$pr = "/Profile:"+$PSScriptRoot+"\CobaltDb.publish.xml"
$dsp = "/DeployScriptPath:"+$PSScriptRoot+"\CobaltDb.DeployScript.sql"
$drp = "/DeployReportPath:"+$PSScriptRoot+"\CobaltDb.DeployReport.xml"
$sf = "/SourceFile:"+$PSScriptRoot+"\CobaltDb.dacpac"

& $sqlpackage $a $tcs $pr $dsp $drp $sf

