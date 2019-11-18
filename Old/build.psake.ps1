# PSake makes variables declared here available in other scriptblocks
Properties {
    $ProjectRoot = $ENV:BHProjectPath
    if (-not $ProjectRoot) {
        $ProjectRoot = $PSScriptRoot
    }

    $Timestamp = Get-date -Format 's'
    $PSVersion = $PSVersionTable.PSVersion.Major
    $lines = '----------------------------------------------------------------------'

    $Verbose = @{}
    if ($ENV:BHCommitMessage -match "!verbose") {
        $Verbose = @{Verbose = $True}
    }

    # Pester
    $TestRootDir = "$ProjectRoot\Tests"
    $TestScripts = Get-ChildItem "$ProjectRoot\Tests\*Tests.ps1"
    $TestFile = "TestResults_PS" + $PSVersion + "_" + $TimeStamp + ".xml"
    
    # Script Analyzer
    [ValidateSet('Error', 'Warning', 'Any', 'None')]
    $ScriptAnalysisFailBuildOnSeverityLevel = 'Error'
    $ScriptAnalyzerSettingsPath = "$ProjectRoot\PSScriptAnalyzerSettings.psd1"
    
    # Build And Clean
    $BuildDir = "$ProjectRoot\Out"
}

Task Default -Depends Test

Task Init {
    Write-Host $lines
    Set-Location $ProjectRoot
    Write-Host "Build System Details:"
    Get-Item ENV:BH*
    Write-Host " "
}



Task Analyze -Depends Init -preaction {Write-Host $lines; Write-Host "Executing Analyze Task"} {
    Write-Host $lines
    $Results = Invoke-ScriptAnalyzer -Path $ENV:BHModulePath -Recurse -Settings $ScriptAnalyzerSettingsPath
    $Results | Select-Object RuleName, Severity, ScriptName, Line, Message | Format-List

    switch ($ScriptAnalysisFailBuildOnSeverityLevel) {
        'None' {
            return
        }
        'Error' {
            Assert -conditionToCheck (
                ($Results | Where-Object Severity -eq 'Error').Count -eq 0
            ) -failureMessage 'One or more ScriptAnalyzer errors were found. Build cannot continue!'
        }
        'Warning' {
            Assert -conditionToCheck (
                ($Results | Where-Object {$_.Severity -eq 'Warning' -or $_.Severity -eq 'Error'}).Count -eq 0
                ) -failureMessage 'One or more ScriptAnalyzer warnings were found. Build cannot continue!'
        }
        default {
            Assert -conditionToCheck ($Results.Count -gt 0) -failureMessage 'One or more ScriptAnalyzer issues were found. Build cannot continue!'
        }
    }
}

Task Test -Depends Analyze -preaction {Write-Host $lines; Write-Host "Executing Test Task"} {
    Write-Host $lines
    Write-Host "STATUS: Testing with PowerShell $PSVersion"

    # Gather test results. Store them in a variable and file
    $TestFilePath = Join-Path -Path $ProjectRoot -ChildPath $TestFile
    $TestResults = Invoke-Pester -Script $TestScripts -PassThru -OutputFormat NUnitXml -OutputFile $TestFilePath -PesterOption @{IncludeVSCodeMarker = $true}

    Remove-Item $TestFilePath -Force -ErrorAction SilentlyContinue

    # Fail build if any tests fail
    if ($TestResults.FailedCount -gt 0) {
        Write-Error "Failed '$($TestResults.FailedCount)' tests, build failed"
    }
    Write-Host " "
}

Task Clean -Depends Analyze -preaction {Write-Host $lines; Write-Host "Executing Clean Task"} {
    Write-Host $lines
    
    Remove-Item -Path $BuildDir -Recurse -Force
    New-Item -Path $BuildDir -ItemType Directory
    
    Write-Host " "
}

Task Build -Depends Clean -preaction {Write-Host $lines; Write-Host "Executing Build Task"} {
    Write-Host $lines

    # Bump the module version
    try {
        Update-Metadata -Path $env:BHPSModuleManifest -Increment Build -ErrorAction stop
    }
    catch {
        Write-Host "Failed to update version for '$env:BHProjectName': $_."
        Write-Host "Continuing with existing version"
    }
    Write-Host " "
}

Task Deploy -Depends Build -preaction {Write-Host $lines; Write-Host "Executing Deploy Task"} {
    Write-Host $lines
    Write-Host "To Do"
    Write-Host " "
}