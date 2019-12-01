function New-PSFormsViewsContent ([string]$AlertType, [string]$AlertMessage, [string]$Message, [string]$SiteRoot, [string]$FileName) {
    $Content = Div -class "response-container" -Content {
        Div -Class "alert alert-$AlertType" -Attributes @{role = "alert" } -Content $AlertMessage
        p -Content $Message
    }
    $Content | Set-Content -Path $(Join-Path -Path $SiteRoot "Views" $FileName) | Out-Null
}