#TODO: Implement
function Set-PSFormsApprovalFile {
    [CmdletBinding()]
    param (
        # GUID For Approval Flow.
        [Parameter(Mandatory=$true, HelpMessage="GUID for approval flow")]
        [string]
        $GUID,
        # Hashtable of values to store in the Approval JSON File.
        [Parameter(Mandatory=$true, HelpMessage="Hashtable of values to store in the Approval JSON File")]
        [hashtable]
        $ApprovalParameters,
        # File path to the root of the PSForms Site
        [Parameter(Mandatory=$true, HelpMessage="File path to the root of the PSForms Site")]
        [string]
        $SiteRoot,
        # The name of the form
        [Parameter(Mandatory=$true, HelpMessage="The name of the form")]
        [string]
        $FormName
    )
    
    process {
        $ApprovalPath =  Join-Path $SiteRoot "\Approval\$FormName.$GUID.json" 
        
        $ApprovalParameters | ConvertTo-Json | Set-Content $ApprovalPath
    }
}