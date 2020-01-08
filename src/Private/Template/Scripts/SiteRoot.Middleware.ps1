New-PolarisRouteMiddleware -Name "SiteRootInjector" -Scriptblock {
    $Request | Add-Member -Name SiteRoot -Value "<%=$PLASTER_DestinationPath%>" -MemberType NoteProperty
}


