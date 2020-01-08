# This is an Auto Generated File, new Route Scripts will be dot sourced here using Add-Content.

# Import Middleware
. .\SiteRoot.Middleware.ps1 # Injects the Site Root Path

# Allows for the loading of static assets such as css, js and images
New-PolarisStaticRoute -RoutePath '/Static' -FolderPath '.\Static\' -EnableDirectoryBrowser $false

