function Get-PSFormsResult {
    [CmdletBinding()]
    param (
        # The Name of the Form to use when getting the htm template
        [Parameter(Mandatory = $true, Position = 0, HelpMessage="The Name of the Form to use when getting the htm template file.")]
        [string]
        $FormName,
        # The Template to get
        [Parameter(Mandatory = $True, Position = 1, HelpMessage="The Template to get.")]
        [ValidateSet("Success", "Error", "Failure")]
        [string]
        $Type,
        # The Title of the Page (Displays in the Browser's Top Bar)
        [Parameter(Mandatory = $true, Position = 2, HelpMessage="The Title of the Page (Displays in the Browser's Top Bar).")]
        [string]
        $Title
    )

    process {
        $PartialHtmlPath = [string]::Format(".\views\{0}.{1}.htm", $FormName, $Type)

        return .\Views\Layout.ps1 -ContentPath $PartialHtmlPath -Title $Title
    }
}