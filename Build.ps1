# Clean The build Directory
Get-ChildItem .\Build\ | Remove-Item -Recurse -Force


# Build c# dll
dotnet build .\src\Project\PSFormsClassLib\PSFormsClassLib.csproj -c Release -o .\Build\bin\

# 'Build' The Powershell Module
Get-ChildItem .\src\ | Copy-Item -Destination .\Build\ -Recurse
