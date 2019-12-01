function New-PSFormsInputTextBox {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)] [ValidateNotNullOrEmpty()] [string] $Name,
        [Parameter(Position = 1)] [string]$DisplayName,
        [Parameter(Position = 2)] [string]$ToolTip,
        [Parameter(Position = 3)] [int]$Rows = 3,
        [Parameter(Position = 4)] [int]$Columns = 8,
        [Parameter(Position = 5)] [switch]$Required,
        [Parameter(Position = 6)] [hashtable]$Attributes = @{}
    )
    
    begin {
        if ([PSFormsClassLib.Helper]::FilePathHasInvalidChars($name)) {
            Write-Error -Message "Name Paramater contains Invalid File Path Characters" -Exception [ArgumentException] -ErrorAction Stop
        }
        if ([string]::IsNullOrWhiteSpace($DisplayName)) {
            $DisplayName = $Name + ":"
        } else {
            $DisplayName = $DisplayName + ":"
        }
    }
    
    process {
        $item = [PSFormsClassLib.PSFormsInputTextBox]::new($Name)
        $item.DisplayName = $DisplayName
        $item.Rows = $Rows
        $item.Columns = $Columns
        
        if ($Required.IsPresent) {
            $item.Required
        }
        
        if (!([string]::IsNullOrWhiteSpace($ToolTip))) {
            $item.ToolTip = $ToolTip
        }
        Write-Output $item
    }
    
    end {
        
    }
}