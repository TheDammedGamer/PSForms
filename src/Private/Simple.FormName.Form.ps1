New-PolarisGetRoute -Path "/:FormName:" -Scriptblock {
    $Response.SetContentType('text/html')
    $HTML = .\Views\Layout.ps1 -ContentPath ".\Views\:FormName:.Form.htm" -Title ":Title:"
    $Response.Send($HTML)
}
