$ModuleManifestName = 'PSFoms.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

Describe -Tags 'PSSA' -Name 'Testing against PSScriptAnalyzer rules' {
    Context 'PSSA Standard Rules' {
        $ScriptAnalyzerSettings = Get-Content -Path ".\PSScriptAnalyzerSettings.psd1" | Out-String | Invoke-Expression
        $AnalyzerIssues = Invoke-ScriptAnalyzer -Path ".\PSFoms.psm1" -Settings ".\PSScriptAnalyzerSettings.psd1"
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
