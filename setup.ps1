Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

#Module setup
$modules = ("DockerMsftProvider", "oh-my-posh", "posh-git", "SqlServer", "PSReadline")

foreach($module in $modules)
{
    If (-not(Get-InstalledModule $module -ErrorAction silentlycontinue)) 
    {
        Write-Output "$module not installed, installing..."
        Install-Module $module}
    Else 
    {
        Write-Output "$module is installed, updating..."
        Update-Module $module
    }
    Write-Output "$module done."
}

#Profile setup
if (!(Test-Path $PROFILE))
{
    Write-Host "Profile file doesn't exist, creating..."
    New-Item -type "file" -path $PROFILE
    Write-Host "$PROFILE created."
}

$profileCommands = ("Import-Module posh-git" `
                  , "Import-Module oh-my-posh" `
                  , "Set-PoshPrompt -Theme blueish")
$profileContents = Get-Content $PROFILE
if($null -eq $profileContents)
{
    $profileContents = ""
}

foreach($profileCommand in $profileCommands)
{
    if($profileContents.Indexof("$profileCommand") -eq -1)
    {
        Write-Output "$profileCommand not found, adding..."
        $addedContents += "`n$profileCommand"
        Write-Output "$profileCommand added."
    }
    else
    {
        Write-Output "$profileCommand already exists."
    }
}
if($addedContents -match "\S")
{
    Write-Output "Updating profile..."
    "$addedContents" |Add-Content -Path $PROFILE
    Write-Output "Done."
}

Write-Output "Now install \CascadiaCode.Nerd.Font.Complete.ttf and select this font in your shell to display glyphs correctly."