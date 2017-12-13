
<#PSScriptInfo

.VERSION 0.1.0

.GUID 0bf5b422-f234-4d83-89ff-8ad8f9026365

.AUTHOR Michael Greene

.COMPANYNAME 

.COPYRIGHT 

.TAGS DSCConfiguration

.LICENSEURI 

.PROJECTURI http://github.com/poshbot/poshbot

.ICONURI 

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS 

.EXTERNALSCRIPTDEPENDENCIES 

.RELEASENOTES


.PRIVATEDATA 

#>

#Requires -Module PoshBot

<# 

.DESCRIPTION 
 Configures a PoshBot server 

#> 

Configuration PoshBot
{
    Import-DSCResource -ModuleName PoshBot
    
    PoshBot BotServer
    {
        Name = 'PoshBot'
        BackEndConfiguration = @{} #TODO
    }

    Service BotService
    {
        Ensure = 'Present'
        Name = 'PoshBot'
        State = 'Running'
    }
}
