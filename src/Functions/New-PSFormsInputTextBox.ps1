function New-PSFormsInputTextBox {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)] [ValidateNotNullOrEmpty()] [string] $Name,
        [Parameter(Position = 1, ValueFromPipelineByPropertyName = $true)] [string]$DisplayName,
        [Parameter(Position = 2, ValueFromPipelineByPropertyName = $true)] [string]$ToolTip,
        [Parameter(Position = 3, ValueFromPipelineByPropertyName = $true)] [int]$Rows = 3,
        [Parameter(Position = 4, ValueFromPipelineByPropertyName = $true)] [int]$Columns = 8,
        [Parameter(Position = 5, ValueFromPipelineByPropertyName = $true)] [hashtable]$Attributes = @{}
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
        
        if (!([string]::IsNullOrWhiteSpace($ToolTip))) {
            $item.ToolTip = $ToolTip
        }
        Write-Output $item
    }
    
    end {
        
    }
}