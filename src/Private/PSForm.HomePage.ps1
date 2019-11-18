
$homeHTML = div -Class "homeBody" -Content {
    h1 -Content "The Site Name"
    
    p -Content "This is a Sample Home Page that needs to be edited:"
    
    p -Content "Below are the Forms that we currently have avaliable:"
    
    Div -Class "card-container" -Content {
        Get-ChildItem "$SiteRoot\Cards" | ForEach-Object {
            Div -Class "card card-width" -Content $(Get-Content $_)
        }
    }
}




$Out = .\Views\Layout.ps1 -ContentPath $homeHTML -Title "Home"

Write-Output $Out