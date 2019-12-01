Import-Module Polaris
Import-Module PSHTML

# Load Config

$config = Get-Content ".\config.json" | ConvertFrom-Json


[int]$Port = 8080
[int]$MaxRunspaces = 5
[bool]$UseHTTPS = $false
[string]$AuthenticationMethod = 'Anonymous' #'Basic', 'Digest', 'IntegratedWindowsAuthentication', 'Negotiate', 'NTLM' # Can be any of these
[bool]$WaitForFinish = $false


. .\Scripts\RouteImport.ps1


$app = Start-Polaris -Port $config.Port -MinRunspaces 1 -MaxRunspaces $config.MaxRunspaces -Https:$UseHTTPS -Auth $config.AuthenticationMethod

if ($config.WaitForFinish) {
    while ($app.Listener.IsListening) {
        Wait-Event callbackcomplete
    }
}