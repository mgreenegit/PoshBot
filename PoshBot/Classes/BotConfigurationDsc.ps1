[DscResource()]
class BotConfigurationDsc {

    [DscProperty(Key)]
    [string]$Name

    [string]$ConfigurationDirectory

    [string]$LogDirectory

    [string]$PluginDirectory

    [string[]]$PluginRepository

    [string[]]$ModuleManifestsToLoad

    [LogLevel]$LogLevel

    [int]$MaxLogSizeMB

    [int]$MaxLogsToKeep

    [bool]$LogCommandHistory

    [int]$CommandHistoryMaxLogSizeMB

    [int]$CommandHistoryMaxLogsToKeep

    [hashtable]$BackendConfiguration

    [hashtable]$PluginConfiguration

    [string[]]$BotAdmins

    [char]$CommandPrefix

    [string[]]$AlternateCommandPrefixes

    [char[]]$AlternateCommandPrefixSeperators

    [string[]]$SendCommandResponseToPrivate

    [bool]$MuteUnknownCommand

    [bool]$AddCommandReactions

    [bool]$DisallowDMs

    [int]$FormatEnumerationLimitOverride

    <#
        DSC resource to create PoshBot configuration
    #>
    [void] Set() {
        $params = @{
            Name                             = $this.Name
            ConfigurationDirectory           = $this.ConfigurationDirectory
            LogDirectory                     = $this.LogDirectory
            PluginDirectory                  = $this.PluginDirectory
            PluginRepository                 = $this.PluginRepository
            ModuleManifestsToLoad            = $this.ModuleManifestsToLoad
            LogLevel                         = $this.LogLevel
            MaxLogSizeMB                     = $this.MaxLogSizeMB
            MaxLogsToKeep                    = $this.MaxLogsToKeep
            LogCommandHistory                = $this.LogCommandHistory
            CommandHistoryMaxLogSizeMB       = $this.CommandHistoryMaxLogSizeMB
            CommandHistoryMaxLogsToKeep      = $this.CommandHistoryMaxLogsToKeep
            BackendConfiguration             = $this.BackendConfiguration
            PluginConfiguration              = $this.PluginConfiguration
            BotAdmins                        = $this.BotAdmins
            CommandPrefix                    = $this.CommandPrefix
            AlternateCommandPrefixes         = $this.AlternateCommandPrefixes
            AlternateCommandPrefixSeperators = $this.AlternateCommandPrefixSeperators
            SendCommandResponseToPrivate     = $this.SendCommandResponseToPrivate
            MuteUnknownCommand               = $this.MuteUnknownCommand
            AddCommandReactions              = $this.AddCommandReactions
            DisallowDMs                      = $this.DisallowDMs
            FormatEnumerationLimitOverride   = $this.FormatEnumerationLimitOverride
        }
        $botConfiguration = New-PoshBotConfiguration @params
        Save-PoshBotConfiguration -inputObject $botConfiguration -path (Join-Path $this.ConfigurationDirectory 'config.psd1') -force
    }

    <#
        DSC resource to test if the machine contains a PoshBot configuration
    #>
    [bool] Test() {
        try {
            $Get = $this.Get()
            if ($Get -eq $this) {
                return $true
            } else {
                return $false
            }
        } catch {
            write-warning 'an error occured when comparing values.  this is likely due to a proeprty having no value in the config file.'
            write-warning 'the error message is:'
            write-warning $_
            return $false
        }
    }

    <#
        DSC resource that returns an instance of this class.
    #>
    [BotConfigurationDsc] Get() {
        if (Test-Path "$($this.ConfigurationDirectory)\config.psd1") {
            $return = New-Object -TypeName 'BotConfigurationDsc'
            $config = Import-PowerShellDataFile -Path "$($this.ConfigurationDirectory)\config.psd1" -ErrorAction SilentlyContinue

            $return.Name = $config.Name
            $return.ConfigurationDirectory = $config.ConfigurationDirectory
            $return.LogDirectory = $config.LogDirectory
            $return.PluginDirectory = $config.PluginDirectory
            $return.PluginRepository = $config.PluginRepository
            $return.ModuleManifestsToLoad = $config.ModuleManifestsToLoad
            $return.LogLevel = $config.LogLevel
            $return.MaxLogSizeMB = $config.MaxLogSizeMB
            $return.MaxLogsToKeep = $config.MaxLogsToKeep
            $return.LogCommandHistory = $config.LogCommandHistory
            $return.CommandHistoryMaxLogSizeMB = $config.CommandHistoryMaxLogSizeMB
            $return.CommandHistoryMaxLogsToKeep = $config.CommandHistoryMaxLogsToKeep
            $return.BackendConfiguration = $config.BackendConfiguration
            $return.PluginConfiguration = $config.PluginConfiguration
            $return.BotAdmins = $config.BotAdmins
            $return.CommandPrefix = $config.CommandPrefix
            $return.AlternateCommandPrefixes = $config.AlternateCommandPrefixes
            $return.AlternateCommandPrefixSeperators = $config.AlternateCommandPrefixSeperators
            $return.SendCommandResponseToPrivate = $config.SendCommandResponseToPrivate
            $return.MuteUnknownCommand = $config.MuteUnknownCommand
            $return.AddCommandReactions = $config.AddCommandReactions
            $return.DisallowDMs = $config.DisallowDMs
            $return.FormatEnumerationLimitOverride = $config.FormatEnumerationLimitOverride

            $file_content = Get-Content -Path "$($this.ConfigurationDirectory)\config.psd1" -ErrorAction SilentlyContinue
        } else {
            $return = New-Object -TypeName 'BotConfigurationDsc'
            $file_content = 'The PoshBot configuration file was not found or did not contain any content.'
        }

        $reasons = @()
        $reasons += @{
            Code   = 'PoshBot:PoshBot:ConfigurationFileContent'
            Phrase = "$file_content"
        }

        $return | Add-Member -MemberType NoteProperty -Name Reasons -Value $reasons

        return $return
    }
}
