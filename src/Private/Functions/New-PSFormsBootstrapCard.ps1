
function New-PSFormsBootstrapCard {
    [CmdletBinding()]
    param (
        # Card Header
        [string]
        $Header,
        # Card Description
        [string]
        $Description,
        # Card Name
        [string]
        $Name,
        # Specifies a path to the root of the PSForms Site
        [string]
        $SiteRoot
    )
    
    try {
        $BootstrapCard = Div -Class "card-body" -Content {
            h5 -Class "card-title" -Content $Header
            p -Class "card-text" -Content $Description
            a -Class "card-link" -href "/$Name" -Content "Go to the Form"
        }
        
        $BootstrapCard | Set-Content -Path $(Join-Path -Path $SiteRoot "Cards" "$Name.htm") | Out-Null
    } catch {
        Write-Error -Message "Error in New-PSFormsBootstrapCard" -Exception $_ -ErrorAction Stop
    }
}


