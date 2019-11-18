class PSFormsInputTextBox {
    # Property: Holds name used to access the input later
    [String] $Name
    # Property: Holds display name used when displaying the name in the form
    [String] $DisplayName
    # Property: Holds the tooltip uising bd-callout-info
    [String] $Tooltip
    # Property: Holds all HTML attributes
    [hashtable]$Attributes
    # Property: Holds the row count
    [Int]$Rows
    # Property: Holds the column count
    [Int]$Cols

    PSFormsInputTextBox([String] $NewName) {
        $this.Name = $NewName
        $this.Attributes = @{ }
    }

    PSFormsInputTextBox([String] $NewName, [string]$display, [string]$hint, [string]$Type, [hashtable]$AttributesIn) {
        $this.Name = $NewName
        $this.DisplayName = $display
        $this.Tooltip = $hint
        $this.InputType = $type
        $this.Attributes = $AttributesIn
    }


    [string] ConvertToHTML() {
        $tooltipID = [String]::Empty
        $attrbis = @{ }
        if ([String]::IsNullOrWhiteSpace($this.Tooltip) -eq $false) {
            $tooltipID = $this.Name + "tooltip"
            $attrbis = $this.Attributes.Add(@{"aria-describedby" = $tooltipID })
        }
        else {
            $attrbis = $this.Attributes
        }

        $HTML = Div -Class "form-group" -Content {
            label -Attributes @{"for" = $this.Name } -Content $this.DisplayName
            textarea -Rows $thos.Rows -Cols $this.Cols.ToString() -Class "form-control" -Id $this.Name -Name $this.Name -Attributes $attrbis
            if ([String]::IsNullOrWhiteSpace($this.Tooltip) -eq $false) {
                small -Id $tooltipID -Class "form-text text-muted" -Content $this.Tooltip
            }
        }

        return $HTML
    }
}