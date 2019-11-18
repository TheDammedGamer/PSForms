
function New-PSFormsBootstrapCard {
    [CmdletBinding()]
    param (
        # Card Header
        [Parameter(Manadatory=$true, Position=0)]
        [string]
        $Header,
        # Card Description
        [Parameter(Manadatory=$true, Position=1)]
        [string]
        $Description,
        # Card Name
        [Parameter(Manadatory=$true, Position=2)]
        [string]
        $Name,
        # Specifies a path to one or more locations.
        [Parameter(Mandatory=$true,
                   Position=3,
                   HelpMessage="Path to the root of the Psforms Site.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $SiteRoot
    )
    
    begin {
        
    }
    
    process {
        $BootstrapCard = Div -Class "card-body" -Content {
            h5 -Class "card-title" -Content $Header
            p -Class "card-text" -Content $Description
            a -Class "card-link" -href "/$Name" -Content "Go to the Form"
        }
        
        $BootstrapCard | Set-Content -Path $(Join-Path -Path $SiteRoot "Cards" "$Name.htm") | Out-Null
    }
    
    end {
        
    }
}


