
$ScriptAnalyzerSettingsPath = Join-Path $(Split-Path $(Get-Item .) -Parent) -ChildPath 'PSScriptAnalyzerSettings.psd1'

$ScriptAnalyzerSettings = Import-PowerShellDataFile $ScriptAnalyzerSettingsPath

Describe -Tags 'PSSA' -Name 'Testing all Functions against PSScriptAnalyzer rules' {
    
    $items = Get-ChildItem -Path ".\Functions\*.ps1" 
    $items += Get-ChildItem -Path ".\Private\Functions\*.ps1"
    
    $ScriptAnalyzerRuleNames = Get-ScriptAnalyzerRule | Select-Object -ExpandProperty RuleName
    
    foreach ($item in $items) {
        Context -Name "Anaylysing - $($item.Name)" {
            $AnalyzerIssues = Invoke-ScriptAnalyzer -Path $item.FullName -Settings $ScriptAnalyzerSettingsPath
            forEach ($Rule in $ScriptAnalyzerRuleNames) {
                $Skip = @{Skip = $False }
                if ($ScriptAnalyzerSettings.ExcludeRules -contains $Rule) {
                    # We still want it in the tests, but since it doesn't actually get tested we will skip
                    $Skip = @{Skip = $True }
                }

                It "Should pass $Rule" @Skip {
                    $Failures = $AnalyzerIssues | Where-Object -Property RuleName -EQ -Value $rule
                    ($Failures | Measure-Object).Count | Should Be 0
                }
            }
        }
    }
}
