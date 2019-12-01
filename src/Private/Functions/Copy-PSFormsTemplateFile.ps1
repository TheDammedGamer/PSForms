function Copy-PSFormsTemplateFile ([hashtable]$Replacements, [string]$Name, [string]$SiteRoot, [string]$FormType) {
    $PrivateFolder = Split-Path $PSScriptRoot -Parent
        
    $FormPath = Join-Path -Path $PrivateFolder $FormType
    $FormOutPath = Join-Path -Path $SiteRoot "Scripts" "$Name.ps1"
                
    $Form = Get-Content -Path $FormPath -Raw
    
    foreach ($Key in $Replacements.Keys) {
        $Form = $Form.Replace($Key, $Replacements[$Key])
    }
    
    Set-Content -Path $FormOutPath -Value $Form | Out-Null
}