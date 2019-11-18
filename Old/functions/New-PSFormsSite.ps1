<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function New-PSFormsSite {
    [CmdletBinding()]
    param (
    # Specifies the path to skeleton the PSForms Site.
    [Parameter(Mandatory=$false,
               Position=0,
               HelpMessage="Specifies the path to skeleton the PSForms Site.")]
    [string]
    $OutputPath = "."
    )

    begin {
        Import-Module Plaster
        $TemplatePath = Join-Path $PSScriptRoot "internal" "Template"
    }

    process {
        Invoke-Plaster -TemplatePath $TemplatePath -DestinationPath $OutputPath -Verbose
    }

    end {

    }
}