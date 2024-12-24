param(
    [Parameter(HelpMessage = "Register Nushell in windows")]
    [switch]$Register = $false,
    [Parameter(HelpMessage = "Remove Nushell's regitration from windows")]
    [switch]$Remove = $false
)

$HKCR = 'Registry::HKEY_CLASSES_ROOT'
$HKCR_nu = "$HKCR\.nu"
$HKLM_PATHEXT = 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Environment'
$HKCU_Explorer = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.nu'

$Nu_AssociationKey = 'NushellScript'

$PATHEXT_Key = 'PATHEXT'
$Default_Key = '(Default)'

# UPDATE PATH HERE IF NEEDED
$Nushell_Ico = '"C:\Program Files\nu\nu.ico"'
$Nushell_Command = '"C:\Program Files\nu\bin\nu.exe" "%1" "%*"'

function Remove-Nushell() {
    if (Test-Path $HKCR_nu) {
        $ftype = (Get-ItemProperty $HKCR_nu)."(Default)"
        $ftypeKey = "$HKCR\$ftype"
        Write-Host "Deleting: $ftypeKey"
        Remove-Item -Path $ftypeKey -Recurse

        Write-Host "Deleting: $HKCR_nu"
        Remove-Item -Path $HKCR_nu -Recurse
    }

    if (Test-Path $HKLM_PATHEXT) {
        Write-Host "Cleaning PATHEXT"
        $pathExt = (Get-ItemProperty $HKLM_PATHEXT).$PATHEXT_Key
        $pathExt = $pathExt -replace ";.NU", "" -replace ";.nu", ""
        Set-ItemProperty -Path $HKLM_PATHEXT -Name $PATHEXT_Key -Value $pathExt
    }

    if (Test-Path $HKCU_Explorer) {
        Write-Host "Deleting file integration in explorer"
        Remove-Item -Path $HKCU_Explorer -Recurse
        Write-Host "Please reboot your machine for changes to take effect"
    }
}

function Register-Nushell() {
    Write-Host "Registering .nu extension"
    New-Item -Path $HKCR_nu -Force | Out-Null
    New-ItemProperty -Path $HKCR_nu -Name $Default_Key -Value $Nu_AssociationKey -Force

    Write-Host "Registering .nu command"
    $associationKey = "$HKCR\$Nu_AssociationKey"
    New-Item -Path $associationKey -Force | Out-Null
    New-ItemProperty -Path $associationKey -Name $Default_Key -Value "Nushell script" -Force

    $iconKey = "$associationKey\DefaultIcon"
    New-Item -Path $iconKey -Force | Out-Null
    New-ItemProperty -Path $iconKey -Name $Default_Key -Value $Nushell_Ico -Force

    
    New-Item -Path "$associationKey\Shell" -Force | Out-Null
    New-Item -Path "$associationKey\Shell\Open" -Force | Out-Null

    $commandKey = "$associationKey\Shell\Open\Command"
    New-Item -Path $commandKey -Force | Out-Null
    New-ItemProperty -Path $commandKey -Name $Default_Key -Value $Nushell_Command -Force

    Write-Host "Updating PATHEXT"
    $pathExt = (Get-ItemProperty $HKLM_PATHEXT).$PATHEXT_Key
    $pathExt = "$pathExt;.NU;.nu"
    Set-ItemProperty -Path $HKLM_PATHEXT -Name $PATHEXT_Key -Value $pathExt

    Write-Host "Nushell is registered, please close all your terminals"
}

$isAdmin = [Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'

if (-not $isAdmin) {
    Write-Host "Please run this script with admin privileges"
}

if (-Not $Register -xor $Remove) {
    Write-Host "Please specify parameter " -NoNewline
    Write-Host "-Register" -ForegroundColor White -NoNewline
    Write-Host " or " -NoNewLine
    Write-Host "-Remove" -ForegroundColor White
    exit 1
}

if ($Register) {
    Register-Nushell
}
else {
    Remove-Nushell
}