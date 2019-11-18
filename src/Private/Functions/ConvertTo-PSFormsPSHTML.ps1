function ConvertTo-PSFormsPSHTML {
    [CmdletBinding()]
    param (
        # A catch all Input Object that we then switch out
        [Parameter(ParamerterSetName = "GenericObject")]
        [System.Object]
        $GenericObject
    )
    
    begin {
        $HTML = " "
    }
    
    process {
        switch ($GenericObject.GetType().ToString()) {
            PSFormsClassLib.PSFormsParagraph { 
                $HTML = Div -Class "form-group" -Content {
                    p -Class "form-text" -Content - $GenericObject.Text
                }
            }
            
            PSFormsClassLib.PSFormsInputTextBox { 
                $tooltipID = [String]::Empty
                if ([String]::IsNullOrWhiteSpace($GenericObject.Tooltip) -eq $false) {
                    $tooltipID = $GenericObject.Name + "tooltip"
                    $GenericObject.Attributes += @{"aria-describedby" = $tooltipID }
                }
                
                $HTML = Div -Class "form-group" -Content {
                    label -Attributes @{"for" = $GenericObject.Name } -Content $GenericObject.DisplayName
                    textarea -Rows $thos.Rows -Cols $GenericObject.Cols.ToString() -Class "form-control" -Id $GenericObject.Name -Name $GenericObject.Name -Attributes $GenericObject.Attributes
                    if ([String]::IsNullOrWhiteSpace($GenericObject.Tooltip) -eq $false) {
                        small -Id $tooltipID -Class "form-text text-muted" -Content $GenericObject.Tooltip
                    }
                }
            }
            
            PSFormsClassLib.PSFormsInputMultiple { 
                $tooltipID = [String]::Empty
                if ([String]::IsNullOrWhiteSpace($GenericObject.Tooltip) -eq $false) {
                    $tooltipID = $GenericObject.Name + "tooltip"

                    $GenericObject.Attributes += @{"aria-describedby" = $tooltipID }
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
            }
            
            PSFormsClassLib.PSFormsInput { 
                $tooltipID = [String]::Empty

                if ([string]::IsNullOrWhiteSpace($GenericObject.Tooltip) -eq $false) {
                    $tooltipID = $GenericObject.Name + "tooltip"
                    $GenericObject.Attributes += @{ "aria-describedby" = $tooltipID }
                }

                $HTML = Div -Class "form-group" -Content {
                    label -Attributes @{"for" = $GenericObject.Name } -Content $GenericObject.DisplayName
                    input -type $GenericObject.InputType -Class "form-control" -Id $GenericObject.Name -name $GenericObject.Name -Attributes $GenericObject.Attributes
                    if ([string]::IsNullOrWhiteSpace($GenericObject.Tooltip) -eq $false) {
                        small -Id $tooltipID -Class "form-text text-muted" -Content $GenericObject.Tooltip
                    }
                }
            }
            Default { 
                Write-Error -Message "Unable to read the type of the GenericObject parameter" -ErrorAction Stop
            }
        }
    }
    
    end {
        Write-Output $HTML
    }
}