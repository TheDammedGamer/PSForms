function New-PSFormsAprovalForm {
    [CmdletBinding()]
    param (
        # Form Name
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateScript( { $_.Contains([System.IO.Path]::InvalidPathChars) -eq $true } )]
        [string]
        $Name,
        # Form Header
        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $Header,
        # Form Description
        [Parameter(Mandatory = $true, Position = 2)]
        [string]
        $Description,
        # Content Array of form content
        [Parameter(Mandatory = $true, Position = 3)]
        [System.Object[]]
        $Content,
        # Success Message
        [Parameter(Mandatory = $true, Position = 4)]
        [string]
        $SuccessMsg,
        # Error Message
        [Parameter(Mandatory = $true, Position = 5)]
        [string[]]
        $ErrorMsg,
        # The Root Directory of the site Defaults to the Current Dir
        [Parameter(Mandatory = $false, Position = 6)]
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
        Write-Verbose  "Generating Form"
        $form = Div -Class "form-container" -Content {
            header -Content {
                H1 -Content $Header -Class "display-3"
            }
            p -Content $Description -Class
            Form -action "/$Name/Submit" -method "get" -Content {
                foreach ($element in $Content) {
                    ConvertTo-PSFormsPSHTML -GenericObject $element
                }
                button -Content "Submit" -Class "btn btn-primary" -Attributes @{type = "submit" }
            }
        }
        $Form | Set-Content -Path $(Join-Path -Path $SiteRoot "Views" "$Name.Form.htm") | Out-Null
        Write-Verbose  "Generated Form"

        Write-Verbose "Generating Sucess View Content"
        New-PSFromsViewsContent -AlertType 'light' -AlertMessage "Form Submitted Sucessfully" -Message $SuccessMsg -SiteRoot $SiteRoot -FileName "$Name.Success.htm"
        
        Write-Verbose "Generating Failure View Template Content"
        New-PSFromsViewsContent -AlertType 'danger' -AlertMessage "Form Submission Denied" -Message ':reason:' -SiteRoot $SiteRoot -FileName "$Name.Failure.htm"

        Write-Verbose "Generating Error View Content"
        New-PSFromsViewsContent -AlertType 'danger' -AlertMessage "Form not Submitted, an Error Occured." -Message $ErrorMsg -SiteRoot $SiteRoot -FileName "$Name.Error.htm"

        Write-Verbose "Generating From Bootstrap Card"
        New-PSFormsBootstrapCard -Header $Header -Description $Description -Name $Name -SiteRoot $SiteRoot

        Write-Verbose "Generate Template Scripts"
        Copy-PSFormsTemplateFile -Name "$Name.Form.ps1" -SiteRoot $SiteRoot -FormType "Simple.FormName.Form.ps1" -Replacements @{
            ":FormName:" = $Name
            ":Title:"   = $Header
        }
        
        Copy-PSFormsTemplateFile -Name "$Name.Submit.ps1" -SiteRoot $SiteRoot -FormType "Simple.FormName.Submit.ps1" -Replacements @{
            ":FormName:" = $Name
            ":Title:"   = $Header
        }
        
        Write-Host "Please update the 'Scripts\$Name.Submit.ps1' file with the code to run, when the form is submitted."
        Write-Verbose "Generated Template Scripts"
        
        Write-Verbose "Update RouteImport.ps1"
        $RouteImport = @("# '$Name' Route Import", ". .\$Name.Submit.ps1", ". .\$Name.Form.ps1")
        
        Add-Content -Value $RouteImport -Path $(Join-Path -Path $SiteRoot "Scripts" "RouteImport.ps1") | Out-Null
        Write-Verbose "Updated RouteImport.ps1"
    }

    end {

    }
}