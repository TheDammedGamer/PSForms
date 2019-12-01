#TODO: Implement
function Set-PSFormsApprovalFile {
    [CmdletBinding()]
    param (
        # GUID For Approval Flow.
        [Parameter(Mandatory=$true, HelpMessage="GUID For Approval Flow")]
        [string]
        $GUID,
        # Hashtable of values to store in the Approval JSON File.
        [Parameter(Mandatory=$true, HelpMessage="Hashtable of values to store in the Approval JSON File")]
        [hashtable]
        $ApprovalParameters,
        # Site Root Path
        [Parameter(Mandatory=$true, HelpMessage="Site Root Path")]
        [string]
        $SiteRoot
    )
    
    begin {
        
    }
    
    process {
        
    }
    
    end {
        
    }
}