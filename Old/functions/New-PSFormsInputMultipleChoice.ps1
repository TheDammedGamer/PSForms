
<#
.SYNOPSIS
    Creates a new Instance of [PSFormsInputMultiple]
.DESCRIPTION
    Creates a new Instance of [PSFormsInputMultiple] which converts into a form input that allows a user to select an entry from a number of options
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    [PSFormsInputMultiple]
.NOTES
    General notes
#>
function New-PSFormsInputMultipleChoice {
    [OutputType([PSFormsInputMultiple])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position = 0)]
        [ValidateScript({$_.Contains([System.IO.Path]::InvalidPathChars) -eq $false})]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory=$true, Position = 1)]
        [string[]] $Options,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string] $ToolTip,

        [Parameter(Mandatory=$false)]
        [string] $DisplayName,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [hashtable] $Attributes = @{}
    )

    process {
        $result = [PSFormsInputMultiple]::new($Name)

        if (Test-Path -Path variable:ToolTip) {
            $result.ToolTip = $ToolTip
        }

        if ([string]::IsNullOrWhiteSpace($DisplayName) -eq $false) {
            $result.DisplayName = $DisplayName + ":"
        } else {
            $result.DisplayName = $Name + ":"
        }
        $result.Attributes = $Attributes
        $result.Options = $Options

        Write-Output $result
    }
}