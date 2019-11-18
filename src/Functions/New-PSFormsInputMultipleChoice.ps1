function New-PSFormsInputMultipleChoice {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $true, Position = 1, ValueFromPipelineByPropertyName = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Options,

        [Parameter(Position = 2, ValueFromPipelineByPropertyName = $true)]
        [string]$DisplayName,

        [Parameter(Position = 3, ValueFromPipelineByPropertyName = $true)]
        [string]$ToolTip,

        [Parameter(Position = 4, ValueFromPipelineByPropertyName = $true)]
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
        
        if ($Options.Length -le 1) {
            Write-Error -Message "Options parameter requires more than option." -Exception [ArgumentException] -ErrorAction Stop
        }
    }
    
    process {
        $item = [PSFormsClassLib.PSFormsInputMultiple]::new($name)
        $item.DisplayName = $DisplayName
        $item.Options = $Options
        $item.Attributes = $Attributes
        
        if (!([string]::IsNullOrWhiteSpace($ToolTip))) {
            $item.ToolTip = $ToolTip
        }
        Write-Output $item
    }
    
    end {
        
    }
}