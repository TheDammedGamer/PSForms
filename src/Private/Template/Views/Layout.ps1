param (
    [Parameter(Mandatory=$true)][string]$ContentPath,
    [Parameter(Mandatory=$true)][string]$Title
 )
#$args[0] = html content file
#$args[1] = The Page Title
doctype
html -Attributes @{lang="en"} {
    head {
        meta -charset 'UTF-8'
        meta -name 'viewport' -content_tag "width=device-width, initial-scale=1, shrink-to-fit=no"

        #Import Bootstrap
        Link -rel 'stylesheet' -href "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" -Integrity "sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" -CrossOrigin "anonymous"

        Link -rel 'stylesheet' -href "/Static/default.css"

        Title -Content $Title
    }
    body {
        # Navbar
        $layoutConfig = Get-Content -Path $(Join-Path $PSScriptRoot 'Layout.json') | ConvertFrom-Json
        nav -Class "navbar fixed-top navbar-expand-lg navbar-dark bg-dark" -Content {
            span -Class "navbar-brand mb-0 h1" -Content $layoutConfig.Title
            Div -Class "collapse navbar-collapse" -Id "mainNavabar" -Content {
                ul -Class "navbar-nav mr-auto" -Content {
                    #navbarItems
                    $layoutConfig.NavItems | ForEach-Object {
                        li -Class "nav-item" -Content {
                            a -Class "nav-link" -href $_.Href -Content $_.Content
                        }
                    }

                }
            }
        }
        
        # Import Partial HTML as specified by $ContentPath
        $PartialHTML = Get-Content -Path $ContentPath -Debug
        Div -Id "container" -Content $PartialHTML -Attributes @{role="main"}

        # Sticky Footer Element
        footer -Class "footer fixed-bottom bg-dark" -Content {
            p -Class "text-light text-center" -Content $layoutConfig.FooterText
            <#
            Div -Class "container cen" -Content {
                p -Class "text-light text-center" -Content $layoutConfig.FooterText
            }
            #>
        }
    }
}

