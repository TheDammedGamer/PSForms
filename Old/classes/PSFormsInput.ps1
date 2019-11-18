class PSFormsInput {
    # Property: Holds name used to access the input later
    [String] $Name
    # Property: Holds display name used when displaying the name in the form
    [String] $DisplayName
    # Property: Holds the tooltip below the input as a small
    [String] $Tooltip
    # Property: Holds the type used for input
    [String] $InputType
    # Property: Holds all HTML attributes not specifed elsewhere
    [hashtable]$Attributes

    PSFormsInput([string]$NewName) {
        $this.Name = $NewName
    }
    PSFormsInput([String] $NewName, [string]$display, [string]$hint, [string]$Type) {
        $this.Name = $NewName
        $this.DisplayName = $display
        $this.Tooltip = $hint
        $this.InputType = $type
    }
    [string]ConvertToHTML() {
        $tooltipID = $this.Name + "tooltip"

        if ([string]::IsNullOrWhiteSpace($this.Tooltip) -eq $false) {
            $this.Attributes += @{ "aria-describedby" = $tooltipID }
        }

        $HTML = Div -Class "form-group" -Content {
            label -Attributes @{"for" = $this.Name } -Content $this.DisplayName
            input -type $this.InputType -Class "form-control" -Id $this.Name -name $this.Name -Attributes $this.Attributes
            if ([string]::IsNullOrWhiteSpace($this.Tooltip) -eq $false) {
                small -Id $tooltipID -Class "form-text text-muted" -Content $this.Tooltip
            }
        }

        return $HTML
    }
}