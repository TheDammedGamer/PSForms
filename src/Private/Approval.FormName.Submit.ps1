New-PolarisGetRoute -Path "/:FormName:/Submit" -Scriptblock {
    Import-Module PSForms
    try {
        # Check out https://github.com/PowerShell/Polaris/blob/master/lib/PolarisRequest.Class.ps1 for the members of The $Request Variable
        # Check out https://github.com/PowerShell/Polaris/blob/master/lib/PolarisResponse.Class.ps1 for the  members of The $Response Variable
        
        # TODO: Inject SiteRoot
        
        $ApprovalGUID = [GUID]::NewGuid().Guid


        # TODO: Implement What you want to do with the Result of the form
        # To Access the a fields on the Form
        $MobileNumber = $Request.Query["MobileNumber"]
        # If Using Windows Auth you can access the user's AD group
        $AccessResult =  $Request.User.IsInRole("FormUsers")


        # An example of the Return statements
        if ($AccessResult) {
            # Form Sumbmission Accepted
            
            # Setting Approval Content
            $Hash = @{
                "User"=$Request.User.Identity.Name
                "RequestIP"= $request.ClientIP
                "RequestTime"= $(Get-Date -Format "s")
            }
            Set-PSFormsApprovalFile -GUID $(New-Guid) -SiteRoot $SiteRoot -FormName ":FormName:" -ApprovalParameters $Hash
            # Making the Response
            $ResponseContent = Get-PSFomsResult -FormName ":FormName:" -Type "Success" -Title ":Title:"
            $Response.StatusCode = 200
            $Response.SetContentType('text/html')
            $Response.Send($ResponseContent)
        } else {
            # Form Sumbission Denied
            # Preparing the response
            $ResponseContent = Get-PSFomsResult -FormName ":FormName:" -Type "Failure" -Title ":Title:"
            $ResponseContent.Replace(':reason:', "You do not have access to use this form. Contact the Service Desk to get access if required.")
            $Response.StatusCode = 403
            $Response.SetContentType('text/html')
            $Response.Send($ResponseContent)
        }
    }
    catch {
        # Form Submission Error
        # Log the error to a file
        $(Get-Date -F 's') + $_.Exception + - $_.InvocationInfo.PositionMessage | Out-File -FilePath '.\Logs\:FormName:.error.log' -Append -Encoding utf8
        
        # Preparing the response
        $ResponseContent = Get-PSFomsResult -FormName ":FormName:" -Type "Error" -Title ":Title:"
        $Response.StatusCode = 500
        $Response.SetContentType('text/html')
        $Response.Send($ResponseContent)
    }
}