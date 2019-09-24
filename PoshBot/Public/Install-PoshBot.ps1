Configuration PoshBot {
    Import-DscResource -ModuleName PowerShellGet
    Import-DscResource -ModuleName PoshBot

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
