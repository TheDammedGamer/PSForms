
<#
.SYNOPSIS
    Creates a new Instance of [PSFormsInputTextBox]
.DESCRIPTION
    Creates a new Instance of [PSFormsInputTextBox] which allows a user to type text into a multi-line text box
.EXAMPLE
    PS C:\> New-PSFormsInputTextBox -Name "description" -DisplayName "If you have any Feedback type it here" -Columns 10 -Rows 3
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    PSFormsInputTextBox
.NOTES
    General notes
#>
function New-PSFormsInputTextBox {
    [OutputType([PSFormsInputTextBox])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position = 0)]
        [ValidateScript({$_.Contains([System.IO.Path]::InvalidPathChars) -eq $false})]
        [string] $Name,

        [Parameter(Mandatory=$false)]
        [string] $DisplayName,

        [Parameter(Mandatory=$false)]
        [string] $ToolTip,

        [Parameter(Mandatory=$false)]
        [int] $Columns,

        [Parameter(Mandatory=$false)]
        [int] $Rows,

        [Parameter(Mandatory=$false)]
        [string] $Placeholder,

        [Parameter(Mandatory=$false)]
        [hashtable] $Attributes = @{}
    )

    process {
        if (Test-Path -Path variable:Placeholder) {
            $Attributes += @{Placeholder = $Placeholder}
        }

        $result = [PSFormsInputTextBox]::new($Name)

        if ([string]::IsNullOrWhiteSpace($DisplayName) -eq $false) {
            $result.DisplayName = $DisplayName + ":"
        } else {
            $result.DisplayName = $Name + ":"
        }
        if (Test-Path -Path variable:ToolTip) {
            $result.ToolTip = $ToolTip
        }
        if (Test-Path -Path variable:Columns) {
            $result.Cols = $Columns
        }
        if (Test-Path -Path variable:Rows) {
            $result.Rows = $Rows
        }
        $result.Attributes = $Attributes

        Write-Output $result
    }
}