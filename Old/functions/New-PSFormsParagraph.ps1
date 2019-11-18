<#
.SYNOPSIS
    Creates a New instance of the [PSFormsParagraph] class.
.DESCRIPTION
    Creates a New instance of the [PSFormsParagraph] class allowing you to insert seperate text inbetween form items.
.EXAMPLE
    PS C:\>$introParagraph = New-PSFormsParagraph -Text "Please use the form below to update your contact numbers in the Address Book."
    This Would Create the Following HTML:
    <div class="form-group">
        <p>Please use the form below to update your contact numbers in the Address Book.</p>
    </div>
.INPUTS
    Inputs to this cmdlet (if any)
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    General notes
#>
function New-PSFormsParagraph {
    [CmdletBinding()]
    [OutputType([PSFormsParagraph])]
    Param (
        [Parameter(Mandatory=$true,
                   Position=0,
                   ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Text
    )

    process {
        $result = [PSFormsParagraph]::new($Text)

        Write-Output $result
    }
}