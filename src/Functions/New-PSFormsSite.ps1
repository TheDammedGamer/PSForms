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
        $TemplatePath = Join-Path $PSScriptRoot "Private" "Template"
    }

    process {
        Invoke-Plaster -TemplatePath $TemplatePath -DestinationPath $OutputPath -Verbose
    }

    end {

    }
}