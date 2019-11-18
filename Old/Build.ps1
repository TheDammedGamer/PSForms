#REGION Functions
function Pack-Module {
    [CmdletBinding()]
    param (
        # Specifies the path to the module to Pack.
        [Parameter(Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            HelpMessage = "Specifies the path to the module to Pack.")]
        [ValidateNotNullOrEmpty()]
        [string]
        $ModulePath,
        # Specifies the output path the module will be packed to.
        [Parameter(Mandatory = $true,
            Position = 1,
            HelpMessage = "Specifies the output path the module will be packed to.")]
        [ValidateNotNullOrEmpty()]
        [string]
        $OutputPath,
        # Specifies the Module Name to be used.
        [Parameter(Mandatory = $true,
            Position = 2,
            HelpMessage = "Specifies the Module Name to be used.")]
        [ValidateNotNullOrEmpty()]
        [string]
        $ModuleName
    )

    begin {
        if (Test-Path $OutputPath) {
            Get-Childitem $OutputPath | ForEach-Object {
                Write-Warning "Output directory is not emppty"
            }
        }
        else {
            New-Item -Path $OutputPath -ItemType Directory | Out-Null
        }
        $FunctionsPath = [System.IO.Path]::Join($ModulePath, "functions")
        $ClassesPath = [System.IO.Path]::Join($ModulePath, "classes")

        $enGBPath = [System.IO.Path]::Join($ModulePath, "en-GB")

        $LicensePath = [System.IO.Path]::Join($ModulePath, "License.md")
        $ReadMePath = [System.IO.Path]::Join($ModulePath, "README.md")
        $PSD1Path = [System.IO.Path]::Join($ModulePath, "$ModuleName.psd1")


        $PSM1Path = [System.IO.Path]::Join($OutputPath, "$ModuleName.psm1")
        
        $ClassesOut = [System.IO.Path]::Join($OutputPath, "Classes\")

        $FunctionsToProcess = @()
        $FunctionsToExport = @()
    }

    process {
        # Function Processing
        Get-ChildItem $FunctionsPath | ForEach-Object {
            $FunctionName = $_.BaseName
            $CurrentFunction = Get-Content $_

            $Header = [string]::Format("# Function: {0} - FilePath: '.\functions\{1}' #", $FunctionName, $_.Name)

            $FunctionsToProcess += " "
            $FunctionsToProcess += "######"
            $FunctionsToProcess += $Header
            $FunctionsToProcess += "######"
            $FunctionsToProcess += " "

            foreach ($line in $CurrentFunction) {
                $FunctionsToProcess += $line
            }
            $FunctionsToProcess += " "

            $FunctionsToExport += [String]::Format("Export-ModuleMember -Function {0}", $FunctionName)

        }
        # End Function Processing

        # Modue File Processing
        $ModuleFile = @()
        $Header = [string]::Format("# Module: {0} - Packed: {1} #", $ModuleName, $(Get-Date -Format "s"))

        $ModuleFile += "######"
        $ModuleFile += $Header
        $ModuleFile += "######"
        $ModuleFile += " "

        foreach ($line in $FunctionsToProcess) {
            $ModuleFile += $line
        }
        $ModuleFile += " "
        $ModuleFile += " "
        $ModuleFile += "######"
        $ModuleFile += "# Classes Import"
        $ModuleFile += "######"
        $ModuleFile += '$Classes = @( Get-ChildItem -Path $PSScriptRoot\Classes\*.ps1 -ErrorAction SilentlyContinue)'
        
        $ModuleFile += 'Foreach ($import in $Classes) {'
        $ModuleFile += '    Try {'
        $ModuleFile += '        . $import.fullname'
        $ModuleFile += '    }'
        $ModuleFile += '    Catch {'
        $ModuleFile += '        Write-Error -Message "Failed to import function $($import.fullname): $_"'
        $ModuleFile += '    }'
        $ModuleFile += '}'

        $ModuleFile += " "
        $ModuleFile += "######"
        $ModuleFile += "# Module Exports"
        $ModuleFile += "######"
        $ModuleFile += " "

        foreach ($line in $FunctionsToExport) {
            $ModuleFile += $line
        }

        Set-Content -Path $PSM1Path -Value $ModuleFile
        # End Modue File Processing
        
        # Classes Processing
        if ($(Test-Path $ClassesOut) -eq $false) {
            New-Item $ClassesOut -ItemType Directory | Out-Null
        }
        
        $ClassFile = @()
        
        Get-ChildItem $ClassesPath | ForEach-Object {
            $ClassFile += "classes\" + $_.Name
            Copy-Item -Path $_ -Destination $ClassesOut
        }
        # End Classes Processing

        # Individual Files
        Copy-Item -Path @($PSD1Path, $ReadMePath, $LicensePath) -Destination $OutputPath
        # End Individual Files
        
        # Internal Files
        Copy-Item -Path .\internal -Destination $OutputPath -Recurse
        
    }

    end {

    }
}



function Generate-MarkdownFiles {
    [CmdletBinding()]
    param (
        [Parameter()][string]$ModulePath,
        [Parameter()][string]$ModuleName,
        [Parameter()][string]$DocsPath,
        [Parameter()][string]$OutputPath
    )
    $moduleInfo = Import-Module -Name "$ModuleName.psd1" -Global -PassThru
    
    
    try {
        if (-not (Test-Path -LiteralPath $DocsPath)) {
            Write-Verbose "Creating Directory"
            New-Item -Path $DocsPath -ItemType Directory | Out-Null
        }

        if (Get-ChildItem -LiteralPath $DocsPath -Filter *.md -Recurse) {
            Write-Verbose "Updating Markdown Help"
            Get-ChildItem -LiteralPath $DocsPath -Directory | ForEach-Object {
                Update-MarkdownHelp -Path $_.FullName | Out-Null
            }
            Write-Verbose "Finished Updating Markdown Help"
        }
        # ErrorAction set to SilentlyContinue so this command will not overwrite an existing MD file.
        $newMDParams = @{
            Module       = $ModuleName
            Locale       = 'en-GB'
            OutputFolder = (Join-Path $DocsPath $Locale)
            ErrorAction  = 'SilentlyContinue'
        }
        Write-Verbose "Creating Markdown Files"
        New-MarkdownHelp @newMDParams | Out-Null
    }
    finally {
        Remove-Module $moduleName
    }
}

#ENDREION 

#$ENV:PSModulePath = $ENV:PSModulePath + ';' + $(Get-Item .\Out\).FullName
#ENDREGION Functions


$ModuleName = "PSForms"

$psd1 = $(Get-Content ".\$ModuleName.psd1" | ConvertFrom-Metadata)[0]
$OutputFolder = ".\Out\" + $ModuleName + "\"

Pack-Module -ModulePath ".\" -OutputPath $OutputFolder -ModuleName $ModuleName

#Update-Metadata -Path "$OutputFolder\$ModuleName.psd1" -PropertyName ScriptsToProcess -Value @('.\Import.ps1')

Generate-MarkdownFiles -ModulePath $OutputFolder -ModuleName $ModuleName -DocsPath ".\docs" -OutputPath $OutputFolder