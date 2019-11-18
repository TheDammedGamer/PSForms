<#
.SYNOPSIS
    Creates a new instance of [PSFomsInput]
.DESCRIPTION
   Creates a new instance of [PSFomsInput] which allows a user to type into a single line text box, use the InpoutType to change the type of display the form has.
   
.EXAMPLE
    PS C:\> New-PSFomsInput -Name "JobTitle" -InputType text -ToolTip "Your Job Title" -DisplayName "DisplayName"
    This Will create a new PSFormsInput Object which you can use in 'New-PSFormsSimpleForm'
.EXAMPLE
    PS C:\> New-PSFomsInput -Name "HomePage" -InputType 'url' -Placeholder "www.google.com" -DisplayName "Your Employee Profile"
    This Will create a new PSFormsInput Object which you can use in 'New-PSFormsSimpleForm'
.EXAMPLE
    PS C:\> New-PSFomsInput -Name "mobile" -InputType tel -Pattern "[0-9]{5,6} [0-9]{6,7}" -DisplayName "Mobile Phone Number"
    This Will create a new PSFormsInput Object which you can use in 'New-PSFormsSimpleForm' which will self validate as a British Phone number
.OUTPUTS
    [PSFomsInput]
.NOTES
    See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Input to check the requirments and options for each InputType
#>
function New-PSFormsInput {
    [OutputType([PSFormsInput])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position = 0)]
        [ValidateScript({ $($_.Contains([System.IO.Path]::InvalidPathChars) -eq $false) -and $($_.Contains(" ") -eq $false) })]
        [string] $Name,

        # Input Types: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/Input
        [Parameter(Mandatory=$true, Position = 1)]
        [ValidateSet("checkbox", "color", "date", "datetime-local", "email", "number", "tel", "text", "time", "url")]
        [string] $InputType,

        [Parameter(Mandatory=$false)]
        [string] $ToolTip,

        [Parameter(Mandatory=$false)]
        [string] $DisplayName,

        [Parameter(Mandatory=$false)]
        [string] $Placeholder,

        [Parameter(Mandatory=$false)]
        [string] $Pattern,

        [Parameter(Mandatory=$false)]
        [hashtable] $Attributes = @{}
    )

    process {
        if ([string]::IsNullOrWhiteSpace($DisplayName)) {
            $DisplayName = $Name
        }
        
        $result = [PSFormsInput]::new($Name)

        if ([string]::IsNullOrWhiteSpace($DisplayName) -eq $false) {
            $result.DisplayName = $DisplayName + ":"
        } else {
            $result.DisplayName = $Name + ":"
        }
        if (Test-Path -Path variable:ToolTip) {
            $result.ToolTip = $ToolTip
        }

        # Add Attibutes
        if (Test-Path -Path variable:Placeholder) {
            $Attributes += @{placeholder = $Placeholder}
        }

        if (Test-Path -Path variable:Pattern) {
            $Attributes += @{pattern = $Pattern}
            # pattern="[0-9]{5,6} [0-9]{6,7}"
        }

        $result.Attributes = $Attributes
        $result.InputType = $InputType
        
        Write-Output $result
    }
}