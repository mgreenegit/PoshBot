$errorActionPreference = 'Stop'
Set-StrictMode -Version 'Latest'

Describe "DSC Tests" {

    BeforeAll {
        $outputDir = Join-Path -Path $env:BHProjectPath -ChildPath 'out'
        $outputModDir = Join-Path -Path $outputDir -ChildPath $env:BHProjectName
        $manifest = Import-PowerShellDataFile -Path $env:BHPSModuleManifest
        $outputModVerDir = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion

        Import-Module $outputModVerDir\$env:BHProjectName.psd1 -Force
    }

    InModuleScope PoshBot {

        $script:TempFolder = "$env:Temp\PoshBotTest\"
        if (Test-Path $script:TempFolder) {
            Remove-Item $script:TempFolder -Recurse -Force
        }

        $script:poshBotObject = [BotConfigurationDsc]::new()
        $script:poshBotObject.Name                     = 'Test'
        $script:poshBotObject.LogLevel                 = 'Info'
        $script:poshBotObject.BotAdmins                = @('name')
        $script:poshBotObject.ConfigurationDirectory   = $script:TempFolder
        $script:poshBotObject.LogDirectory             = $script:TempFolder
        $script:poshBotObject.PluginDirectory          = $script:TempFolder
        $script:poshBotObject.BackendConfiguration = @{
            Name                = 'TeamsBackend'
            BotName             = 'Test'
            TeamId              = '<TEAMS-ID>'
            ServiceBusNamespace = '<SERVICE-BUS-NAMESPACE-NAME>'
            QueueName           = 'messages'
            AccessKeyName       = 'receive'
            AccessKey           = '<SAS-KEY>' | ConvertTo-SecureString -AsPlainText -Force
            Credential          = [pscredential]::new(
                '<BOT-APP-ID>',
                ('<BOT-APP-PASSWORD>' | ConvertTo-SecureString -AsPlainText -Force)
            )
        }

        Context "PoshBot\Get" {
            $Get = $script:poshBotObject.Get()

            It 'Should return a hashtable' {
                $Get.Reasons | Should -BeOfType 'Hashtable'
            }

            It 'Reasons should be an embedded hashtable' {
                $Get.Reasons | Should -BeOfType 'Hashtable'
            }

            It 'Should have at least one reasons code' {
                $Get.Reasons[0] | ForEach-Object Code | Should -BeOfType 'String'
                $Get.Reasons[0] | ForEach-Object Code | Should -Match "PoshBot:PoshBot:"
            }

            It 'Should have at least one reasons phrase' {
                $Get.Reasons | ForEach-Object Phrase | Should -BeOfType 'String'
            }
        }

        Context "PoshBot\Test" {
            $Test = $script:poshBotObject.Test()

            It 'fails Test before Set is run' {
                $Test | Should -BeFalse
            }
        }

        Context "PoshBot\Set" {

            It "should not throw an error" {
                { $script:poshBotObject.Set() } | Should -Not -Throw
            }
        }

        Context "PoshBot\Test" {
            $Test = $script:poshBotObject.Test()

            It 'passes Test after Set is run' {
                $Test | Should -BeTrue
            }
        }

    }
}
