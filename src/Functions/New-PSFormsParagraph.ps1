function New-PSFormsParagraph {
    [CmdletBinding()]
    param (
        # Paragraph Text
        [Parameter(Mandatory= $True, Position=0, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Text,
        # p tag attribute
        [Parameter(Mandatory= $True, Position=1)]
        [ValidateNotNullOrEmpty()]
        [hashtable] $Attributes = @{}
    )
    
    begin {
        if ([string]::IsNullOrWhiteSpace($Text)){
                Write-Error -Message "Text Parameter is empty or White Space." -Exception [ArgumentException] -ErrorAction Stop
        }
    }
    
    process {
        $item = [PSFormsParagraph]::new($Text)
        $item.Attributes = $Attributes
        Write-Object $item
    }
    
    end {
        
    }
}