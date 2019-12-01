New-PolarisGetRoute -Path "/:FormName:/Submit" -Scriptblock {
    Import-Module PSForms
    try {
        # Check out https://github.com/PowerShell/Polaris/blob/master/lib/PolarisRequest.Class.ps1 for the members of The $Request Variable
        # Check out https://github.com/PowerShell/Polaris/blob/master/lib/PolarisResponse.Class.ps1 for the  members of The $Response Variable
        
        $ApprovalGUID = [GUID]::NewGuid().Guid


        #TODO: Implement What you want to do with the Result of the form
        # To Access the a fiels on the Form
        $MobileNumber = $Request.Query["MobileNumber"]
        # If Using Windows Auth you can access the user's AD group
        $AccessResult =  $Request.User.IsInRole("FormUsers")


        #TODO: An example of the Return statements
        if ($AccessResult) {
            $ResponseContent = Get-PSFomsResult -FormName ":FormName:" -Type "Success" -Title ":Title:"
            $Response.StatusCode = 200
            $Response.SetContentType('text/html')
            $Response.Send($ResponseContent)
        } else {
            $ResponseContent = Get-PSFomsResult -FormName ":FormName:" -Type "Failure" -Title ":Title:"
            $ResponseContent.Replace(':reason:', "You do not have access to use this form. Contact the Service Desk to get access if required.")
            $Response.StatusCode = 403
            $Response.SetContentType('text/html')
            $Response.Send($ResponseContent)
        }
    }
    catch {
        #TODO: Log the Error Somewhere in an error.log file for instance
        $ResponseContent = Get-PSFomsResult -FormName ":FormName:" -Type "Error" -Title ":Title:"
        $Response.StatusCode = 500
        $Response.SetContentType('text/html')
        $Response.Send($ResponseContent)
    }
}