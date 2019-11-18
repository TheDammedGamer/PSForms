class PSFormsInputMultiple {
    # Property: Holds name used to access the input later
    [String] $Name
    # Property: Holds display name used when displaying the name in the form
    [String] $DisplayName
    # Property: Holds the tooltip
    [String] $Tooltip
    # Property: Holds all Options
    [String[]]$Options
    # Property: Holds all HTML attributes
    [hashtable]$Attributes
    PSFormsInputMultiple([string]$InputName) {
        $this.Name = $InputName
    }

    PSFormsInputMultiple([String] $NewName, [string]$display, [string[]]$OptionsIn, [string[]]$AttributesIn, [string]$hint = [string]::Empty) {
        $this.Name = $NewName
        $this.DisplayName = $display
        $this.Tooltip = $hint
        $this.Options = $OptionsIn
        $this.Attributes = $AttributesIn
    }

    [string] ConvertToHTML() {
        $tooltipID = [String]::Empty
        if ([String]::IsNullOrWhiteSpace($this.Tooltip) -eq $false) {
            $tooltipID = $this.Name + "tooltip"

            $this.Attributes += @{"aria-describedby" = $tooltipID }
        }

        $HTML = Div -Class "form-group" -Content {
            label -Content $this.DisplayName -Attributes @{"for" = $this.Name }
            selecttag -Class "form-control" -Id $this.Name -Name $this.Name -Attributes $this.Attributes -Content {
                foreach ($option in $this.Options) {
                    option -Content $option
                }
            }
            if ([String]::IsNullOrWhiteSpace($this.Tooltip) -eq $false) {
                small -Id $tooltipID -Class "form-text text-muted" -Content $this.Tooltip
            }
        }
        return $HTML
    }
}