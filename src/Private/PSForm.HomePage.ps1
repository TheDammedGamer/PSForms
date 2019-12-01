
$homeHTML = div -Class "homeBody" -Content {
    Div -Class "jumbotron" -Content {
        H1 -Class "display-4" -Content ":SiteName:"
        p -Class "lead" -Content ":Company:'s IT Department's Web Form Site."
        hr -Class "my-4"
        p -Content "If you have any issue using these Forms, please report them to the IT Service Desk"
    }
    
    p -Content "Below are the Forms that we currently have avaliable:"
    
    Div -Class "card-container" -Content {
        Get-ChildItem "$SiteRoot\Cards" | ForEach-Object {
            Div -Class "card card-width" -Content $(Get-Content $_)
        }
    }
}

$Out = .\Views\Layout.ps1 -ContentPath $homeHTML -Title "Home"

Write-Output $Out