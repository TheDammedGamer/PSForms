function New-PSFormsSimpleForm {
    [CmdletBinding()]
    param (
        # Form Name
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateScript({$_.Contains([System.IO.Path]::InvalidPathChars) -eq $true})]
        [string]
        $Name,
        # Form Header
        [Parameter(Mandatory=$true,Position=1)]
        [string]
        $Header,
        # Form Description
        [Parameter(Mandatory=$true,Position=2)]
        [string]
        $Description,
        # Content Array of form content
        [Parameter(Mandatory=$true,Position=3)]
        [System.Object[]]
        $Content,
        # Success Message
        [Parameter(Mandatory=$true,Position=4)]
        [string]
        $SuccessMsg,
        # Error Message
        [Parameter(Mandatory=$true,Position=5)]
        [string[]]
        $ErrorMsg,
        # The Root Directory of the site Defaults to the Current Dir
        [Parameter(Mandatory=$false, Position=6)]
        [string]
        $SiteRoot = "."
    )

    begin {
        # Ensure The Skeleton command has been run
        if (!(Test-Path -Path "$SiteRoot\Start.ps1") -or !(Test-Path -Path "$SiteRoot\Views\Layout.ps1") -or !(Test-Path -Path "$SiteRoot\Static")) {
            Write-Error -Message "Please Ensure that the 'New-PSFomsSite' Command has been run in the Site Root directory." -ErrorAction Stop
        }
        
        # Check for Duplicate content names to ensure that ids arent repeated and the form is sent with non duplicate ids
        [string[]]$names = @()
        foreach ($element in $Content) {
            if ($names.Contains($element.Name.ToLower())) {
                Write-Error -Message  "Multiple content elements with the same name present. Theses need to be unique as they are converted to HTML ids." -ErrorAction Stop
            }
            $names += $element.Name.ToLower()
        }
        $names = $null
    }

    process {
        # Generate Form
        $form = Div -Class "form-container" -Content {
            header -Content {
                H1 -Content $Header -Class "display-3"
            }
            p -Content $Description -Class
            Form -action "/$Name/Submit" -method "get" -Content {
                foreach ($element in $Content) {
                    ConvertTo-PSFormsPSHTML -GenericObject $element
                }
                button -Content "Submit" -Class "btn btn-primary" -Attributes @{type="submit"}
            }
        }
        $Form | Set-Content -Path $(Join-Path -Path $SiteRoot "Views" "$Name.Form.htm") | Out-Null
        # Generated Form

        # Generate Sucess Content
        $SucessContent = Div -class "response-container" -Content {
            Div -Class "alert alert-light" -Attributes @{role="alert"} -Content "Form Submitted Sucessfully"
            p -Content $SuccessMsg
        }
        $SucessContent | Set-Content -Path $(Join-Path -Path $SiteRoot "Views" "$Name.Success.htm") | Out-Null
        # Generated Sucess Content

        # Generate Failure Content
        $FailureContent = Div -class "response-container" -Content {
            Div -Class "alert alert-danger" -Attributes @{role="alert"} -Content "Form Submission Denied"
            p -Content ":reason:" # Will be replaced at runtime as the reason should be changed.
        }
        $FailureContent | Set-Content -Path $(Join-Path -Path $SiteRoot "Views" "$Name.Failure.htm") | Out-Null
        # Generated Failure Content

        # Generate Error Content
        $ErrorContent = Div -class "response-container" -Content {
            Div -Class "alert alert-danger" -Attributes @{role="alert"} -Content "Form not Submitted, an Error Occured."
            p -Content $ErrorMsg
        }
        $ErrorContent | Set-Content -Path $(Join-Path -Path $SiteRoot "Views" "$Name.Error.htm") | Out-Null
        # Generated Error Content

        # Generate Card
        $BootstrapCard = Div -Class "card card-width" -Content {
            Div -Class "card-body" -Content {
                h5 -Class "card-title" -Content $Header
                p -Class "card-text" -Content $Description
                a -Class "card-link" -href "/$Name" -Content "Go to the Form"
            }
        }
        $BootstrapCard | Set-Content -Path $(Join-Path -Path $SiteRoot "Cards" "$Name.htm") | Out-Null
        # Generated Card

        # Generate Template Scripts
        $TemplateFilesParent = Join-Path -Path $PSScriptRoot "Private"
        
        $FormPath = Join-Path -Path $TemplateFilesParent "Simple.FormName.Form.ps1"
        $FormOutPath = Join-Path -Path $SiteRoot "Scripts" "$Name.Form.ps1"
                
        $Form = Get-Content -Path $FormPath
        $Form = $Form.Replace(':FormName:', $Name).Replace(':Title:', $Header)
        Set-Content -Path $FormOutPath -Value $Form | Out-Null
        
        $FormPath = Join-Path -Path $TemplateFilesParent "Simple.FormName.Submit.ps1"
        $FormOutPath = Join-Path -Path $SiteRoot "Scripts" "$Name.Submit.ps1"
        
        $Form = Get-Content -Path $FormPath
        $Form = $Form.Replace(':FormName:', $Name).Replace(':Title:', $Header)
        Set-Content -Path $FormOutPath -Value $Form | Out-Null
        
        Write-Host "Please update the 'Scripts\$Name.Submit.ps1' file with the code that you need to run when the form is submitted."
        # Generated Template Scripts
        
        # Update RouteImport.ps1
        $RouteImport = @( [string]::Format("# {0} Route Import", $Name), [string]::Format(". .\{0}.Submit.ps1", $Name), [string]::Format(". .\{0}.Form.ps1", $Name) )
        
        Add-Content -Value $RouteImport -Path $(Join-Path -Path $SiteRoot "Scripts" "RouteImport.ps1") | Out-Null
        # Updated RouteImport.ps1
    }

    end {

    }
}