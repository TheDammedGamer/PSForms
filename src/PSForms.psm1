# Implement your module commands in this script.
. .\classes\PSFormsInput.ps1
. .\classes\PSFormsInputMultiple.ps1
. .\classes\PSFormsInputTetxtBox.ps1
. .\classes\PSFormsParagraph.ps1

. .\functions\Get-PSFormsResult.ps1
. .\functions\New-PSFormsInput.ps1
. .\functions\New-PSFormsInputMultipleChoice.ps1
. .\functions\New-PSFormsInputTextBox.ps1
. .\functions\New-PSFormsInstance.ps1
. .\functions\New-PSFormsParagraph.ps1
. .\functions\New-PSFormsSimpleForm.ps1
. .\functions\New-PSFormsSite.ps1

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Export-ModuleMember -Function *-*
