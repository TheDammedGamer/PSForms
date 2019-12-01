function ConvertTo-PSFormsPSHTML {
    [CmdletBinding()]
    param (
        # A catch all Input Object that we then switch out
        [System.Object]
        $GenericObject
    )
    
    begin {
        $HTML = " "
        Write-Verbose " Starting ConvertTo-PSFormsPSHTML"
        Write-Verbose "  Processing Object Type: $($GenericObject.GetType().ToString())"
    }
    
    process {
        switch ($GenericObject.GetType().ToString()) {
            PSFormsClassLib.PSFormsParagraph { 
                
                $HTML = Div -Class "form-group" -Content {
                    p -Class "form-text" -Content - $GenericObject.Text
                }
                Write-Verbose "  Wrote PSFormsParagraph Object"
            }
            
            PSFormsClassLib.PSFormsInputTextBox { 
                
                $tooltipID = [String]::Empty
                if ([String]::IsNullOrWhiteSpace($GenericObject.Tooltip) -eq $false) {
                    $tooltipID = $GenericObject.Name + "tooltip"
                    try {
                        $GenericObject.Attributes += @{"aria-describedby" = $tooltipID }
                    } Catch {
                        $GenericObject.Attributes["aria-describedby"] = $tooltipID
                    }
                }
                
                $HTML = Div -Class "form-group" -Content {
                    label -Attributes @{"for" = $GenericObject.Name } -Content $GenericObject.DisplayName
                    textarea -Rows $GenericObject.Rows -Cols $GenericObject.Columns.ToString() -Class "form-control" -Id $GenericObject.Name -Name $GenericObject.Name -Attributes $GenericObject.Attributes -title $GenericObject.DisplayName
                    
                    if ([String]::IsNullOrWhiteSpace($GenericObject.Tooltip) -eq $false) {
                        small -Id $tooltipID -Class "form-text text-muted" -Content $GenericObject.Tooltip
                    }
                }
                
                Write-Verbose "  Wrote PSFormsInputTextBox Object"
            }
            
            PSFormsClassLib.PSFormsInputMultiple { 
                
                $tooltipID = [String]::Empty
                if ([String]::IsNullOrWhiteSpace($GenericObject.Tooltip) -eq $false) {
                    $tooltipID = $GenericObject.Name + "tooltip"
                    try {
                        $GenericObject.Attributes += @{"aria-describedby" = $tooltipID }
                    } Catch {
                        $GenericObject.Attributes["aria-describedby"] = $tooltipID
                    }
                }

                $HTML = Div -Class "form-group" -Content {
                    label -Content $GenericObject.DisplayName -Attributes @{"for" = $GenericObject.Name }
                    selecttag -Class "form-control" -Id $GenericObject.Name -Name $GenericObject.Name -Attributes $GenericObject.Attributes -Content {
                        foreach ($option in $GenericObject.Options) {
                            option -Content $option
                        }
                    }
                    if ([String]::IsNullOrWhiteSpace($GenericObject.Tooltip) -eq $false) {
                        small -Id $tooltipID -Class "form-text text-muted" -Content $GenericObject.Tooltip
                    }
                }
                Write-Verbose "  Wrote PSFormsInputMultiple Object"
            }
            
            PSFormsClassLib.PSFormsInput {
               
                $tooltipID = [String]::Empty
                
                if ([string]::IsNullOrWhiteSpace($GenericObject.Tooltip) -eq $false) {
                    $tooltipID = $GenericObject.Name + "tooltip"
                    try {
                        $GenericObject.Attributes += @{"aria-describedby" = $tooltipID }
                    } Catch {
                        $GenericObject.Attributes["aria-describedby"] = $tooltipID
                    }
                }
                
                $HTML = Div -Class "form-group" -Content {
                    label -Attributes @{"for" = $GenericObject.Name } -Content $GenericObject.DisplayName
                    input -type $GenericObject.InputType -Class "form-control" -Id $GenericObject.Name -name $GenericObject.Name -Attributes $GenericObject.Attributes
                    if ([string]::IsNullOrWhiteSpace($GenericObject.Tooltip) -eq $false) {
                        small -Id $tooltipID -Class "form-text text-muted" -Content $GenericObject.Tooltip
                    }
                }
                Write-Verbose "  Wrote PSFormsInput Object"
            }
            Default { 
                Write-Error -Message "Unable to read the type of the GenericObject parameter" -ErrorAction Stop
            }
        }
    }
    
    end {
        Write-Verbose " Finishing ConvertTo-PSFormsPSHTML"
        Write-Output $HTML
    }
}