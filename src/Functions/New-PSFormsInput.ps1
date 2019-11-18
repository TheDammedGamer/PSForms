function New-PSFormsInput {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Position = 1, ValueFromPipelineByPropertyName = $true)]
        [string]$DisplayName,
        
        [Parameter(Position = 2, ValueFromPipelineByPropertyName = $true)]
        [ValidateSet("checkbox", "color", "date", "datetime-local", "email", "number", "tel", "text", "time", "url")]
        [string]$InputType = "text",

        [Parameter(Position = 3, ValueFromPipelineByPropertyName = $true)]
        [string]$ToolTip,
        
        [Parameter(Position = 4, ValueFromPipelineByPropertyName = $true)]
        [string]$Pattern,
        
        [Parameter(Position = 5, ValueFromPipelineByPropertyName = $true)]
        [string]$Placeholder,

        [Parameter(Position = 6, ValueFromPipelineByPropertyName = $true)]
        [Hashtable]$Attributes = @{}
    )
    
    begin {
        if ([PSFormsClassLib.Helper]::FilePathHasInvalidChars($name)) {
            Write-Error -Message "Name Paramater contains Invalid File Path Characters." -Exception [ArgumentException] -ErrorAction Stop
        }
        if ([string]::IsNullOrWhiteSpace($DisplayName)) {
            $DisplayName = $Name + ":"
        } else {
            $DisplayName = $DisplayName + ":"
        }
        
        if (!([string]::IsNullOrWhiteSpace($Pattern))) {
            $Attributes += @{"pattern" = $Pattern}
        }
        
        if (!([string]::IsNullOrWhiteSpace($Placeholder))) {
            $Attributes += @{"placeholder" = $Placeholder}
        }
    }
    
    process {
        $item = [PSFormsClassLib.PSFormsInput]::new($name)
        $item.DisplayName = $DisplayName
        $item.InputType = $InputType
        $item.Attributes = $Attributes
        
        if (!([string]::IsNullOrWhiteSpace($ToolTip))) {
            $item.ToolTip = $ToolTip
        }
        Write-Output $item
    }
    
    end {
        
    }
}