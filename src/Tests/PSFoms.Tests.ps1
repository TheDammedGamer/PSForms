$ModuleManifestName = 'PSForms.psd1'
$ModuleManifestPath = ".\$ModuleManifestName"

$ScriptAnalyzerSettingsPath = Join-Path $(Split-Path $(Get-Item .) -Parent) -ChildPath 'PSScriptAnalyzerSettings.psd1'

$ScriptAnalyzerSettings = Import-PowerShellDataFile $ScriptAnalyzerSettingsPath

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

Describe -Tags 'PSSA' -Name 'Testing against PSScriptAnalyzer rules' {
    Context 'PSSA Standard Rules' {
        
        $AnalyzerIssues = Invoke-ScriptAnalyzer -Path ".\PSForms.psm1" -Settings $ScriptAnalyzerSettingsPath
        $ScriptAnalyzerRuleNames = Get-ScriptAnalyzerRule | Select-Object -ExpandProperty RuleName
        forEach ($Rule in $ScriptAnalyzerRuleNames) {
            $Skip = @{Skip=$False}
            if ($ScriptAnalyzerSettings.ExcludeRules -contains $Rule) {
                # We still want it in the tests, but since it doesn't actually get tested we will skip
                $Skip = @{Skip = $True}
            }

            It "Should pass $Rule" @Skip {
                $Failures = $AnalyzerIssues | Where-Object -Property RuleName -EQ -Value $rule
                ($Failures | Measure-Object).Count | Should Be 0
            }
        }
    }
}
