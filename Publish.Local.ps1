$PublishTo = $ENV:PSModulePath.Split(';')[0] # Get the First Module path this should be the one located beside $Profile
$ModuleName = "PSForms"
$LocalBuildPath = ".\Build"

$PublishModuleToFolder = Join-Path -Path $PublishTo -ChildPath $ModuleName

Copy-Item $LocalBuildPath -Destination $PublishModuleToFolder -Recurse -Force