
# Track bot instnace(s) running as PS job
$script:botTracker = @{}

<#
    DSC Resource
#>
[DscResource()]
class PoshBotConfiguration
{
    [DscProperty(Key)]
    [string]$Name = 'PoshBot',

    [DscProperty()]
    [string]$ConfigurationDirectory = (Join-Path -Path $env:SystemRoot -ChildPath 'poshbot'),
    
    [DscProperty()]
    [string]$LogDirectory = (Join-Path -Path $env:SystemRoot -ChildPath 'poshbot'),

    [DscProperty()]
    [string]$PluginDirectory = (Join-Path -Path $env:SystemRoot -ChildPath 'poshbot'),

    [DscProperty()]
    [string[]]$PluginRepository = @('PSGallery'),

    [DscProperty()]
    [string[]]$ModuleManifestsToLoad = @(),

    [DscProperty()]
    [LogLevel]$LogLevel = [LogLevel]::Verbose,

    [DscProperty()]
    [int]$MaxLogSizeMB = 10,

    [DscProperty()]
    [int]$MaxLogsToKeep = 5,

    [DscProperty()]
    [bool]$LogCommandHistory = $true,

    [DscProperty()]
    [int]$CommandHistoryMaxLogSizeMB = 10,

    [DscProperty()]
    [int]$CommandHistoryMaxLogsToKeep = 5,

    [DscProperty(Mandatory)]
    [hashtable]$BackendConfiguration = @{},

    [DscProperty()]
    [hashtable]$PluginConfiguration = @{},

    [DscProperty()]
    [string[]]$BotAdmins = @(),

    [DscProperty()]
    [char]$CommandPrefix = '!',

    [DscProperty()]
    [string[]]$AlternateCommandPrefixes = @('poshbot'),

    [DscProperty()]
    [char[]]$AlternateCommandPrefixSeperators = @(':', ',', ';'),

    [DscProperty()]
    [string[]]$SendCommandResponseToPrivate = @(),

    [DscProperty()]
    [bool]$MuteUnknownCommand = $false,

    [DscProperty()]
    [bool]$AddCommandReactions = $true,

    [DscProperty()]
    [int]$ApprovalExpireMinutes = 30,

    [DscProperty()]
    [hashtable[]]$ApprovalCommandConfigurations = @()

    <#
        Create PoshBot configuration
    #>
    [void] Set()
    {
        $botConfiguration = New-PoshBotConfiguration @this
        Save-PoshBotConfiguration -inputObject $botConfiguration -path (Join-Path $this.ConfigurationDirectory 'config.psd1')

        #TODO - Ensure present/absent
    }

    <#
        Tests if the machine contains a PoshBot configuration
    #>
    [bool] Test()
    {
        if ((Import-PowerShellDataFile -Path (Join-Path $this.ConfigurationDirectory 'config.psd1') -ErrorAction SilentlyContinue) -eq $this)
        {
            return $true
        }
        else
        {
            return $false
        }
    }

    <#
        Returns an instance of this class.
    #>
    [PoshBotConfiguration] Get()
    {
        $this = Import-PowerShellDataFile -Path (Join-Path $this.ConfigurationDirectory 'config.psd1') -ErrorAction SilentlyContinue
        return $this
    }
}
