function New-PSFormsInputMultipleChoice {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)] [ValidateNotNullOrEmpty()] [string]$Name,
        [Parameter(Mandatory = $true, Position = 1)] [ValidateNotNullOrEmpty()] [string[]]$Options,
        [Parameter(Position = 2)] [string]$DisplayName,
        [Parameter(Position = 3)] [string]$ToolTip,
        [Parameter(Position = 4)] [switch]$Required,
        [Parameter(Position = 5)] [Hashtable]$Attributes = @{ }
    )
    
    begin {
        if ([PSFormsClassLib.Helper]::FilePathHasInvalidChars($name)) {
            Write-Error -Message "Name Paramater contains Invalid File Path Characters." -Exception [ArgumentException] -ErrorAction Stop
        }
        if ([string]::IsNullOrWhiteSpace($DisplayName)) {
            $DisplayName = $Name + ":"
        }
        else {
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