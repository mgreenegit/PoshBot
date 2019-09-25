Configuration PoshBot {
    Import-DscResource -ModuleName @{ModuleName = 'PowerShellGet'; ModuleVersion = '2.1.2'}
    Import-DscResource -ModuleName @{ModuleName = 'PoshBot'; ModuleVersion = '0.11.9'}

    Node localhost
    {
        PSModule 'PoshBot'
        {
            Name         = 'PoshBot'
            Repository   = 'PSGallery'
        }

        PoshBotConfiguration 'PoshBotConfiguration'
        {
            Name    = 'PoshBot'

        }
    }
}

PoshBot -out "$env:SYSTEMDRIVE\ProgramData\PoshBot\MOF"
Start-DscConfiguration -Wait -Verbose -Path "$env:SYSTEMDRIVE\ProgramData\PoshBot\MOF" -Force
