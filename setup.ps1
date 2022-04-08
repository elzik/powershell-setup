Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

#Module setup
$modules = ("DockerMsftProvider", "oh-my-posh", "posh-git", "SqlServer", "PSReadline", "Terminal-Icons")

foreach($module in $modules)
{
    If (-not(Get-InstalledModule $module -ErrorAction silentlycontinue)) 
    {
        Write-Output "$module not installed, installing..."
        Install-Module $module -AllowPrerelease}
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
                  , "Import-Module PSReadline" `
                  , "Set-PoshPrompt -Theme blueish" `
                  , "Import-Module -Name Terminal-Icons")
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

#Setup PSReadline
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -EditMode Windows

Write-Output "Now install a font which includes programming ligatures. 'Caskaydia Cove Nerd Font Complete Windows Compatible.ttf' from Nerd Fonts is recommended. https://www.nerdfonts.com/font-downloads"