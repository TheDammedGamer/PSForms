function New-PSFormsParagraph {
    [CmdletBinding()]
    param (
        # Paragraph Text
        [Parameter(Mandatory= $True, Position=0, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Text,
        # p tag attribute
        [Parameter(Mandatory= $false, Position=1)]
        [hashtable] $Attributes = @{}
    )
    
    begin {
        if ([string]::IsNullOrWhiteSpace($Text)){
                Write-Error -Message "Text Parameter is empty or White Space." -Exception [ArgumentException] -ErrorAction Stop
        }
    }
    
    process {
        $item = [PSFormsClassLib.PSFormsParagraph]::new($Text)
        $item.Attributes = $Attributes
        Write-Object $item
    }
    
    end {
        
    }
}