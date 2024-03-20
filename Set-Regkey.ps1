Function Test-RegistryValue() {
    param
    (
        [string]$key,
        [string]$property
    )

    $exists = $false
    try {
        Get-ItemProperty -LiteralPath $key -Name $property | Out-Null
        $exists = $true
    }
    catch {
        $exists = $false
    }
    return $exists
}

function Set-RegistryKey {
    param (
        [string]$key,      # Ex. 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
        [string]$property, # Ex. 'SettingsPageVisibility'
        [string]$value     # Ex. 'Hide:privacy-location'
    )

    #does the path exist?  If not, make it
    if (-not (Test-Path -Path $key)) {
        Write-Host "Path: $key not found, Creating path"
        New-Item -Path $key -Force
    }

    #does the key exist?
    if (Test-RegistryValue $key $property) {
        #modify the key and return
        Write-Host "Key already exists, setting property"
        Set-ItemProperty -Path $key -Name $property -Value $value
        return
    }

    #create a new key
    try {
        Write-Host "Creating registry key: $property"
        New-ItemProperty -Path $key -Name $property -Value $value
    }
    catch {
        Write-Error "Failed to create new item property: $property at path: $key"
        return
    }

    Write-Host "Done creating registry key"
    
}

$Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
$Property = 'SettingsPageVisibility'
$Value = 'Hide:privacy-location'

#call the function
Set-RegistryKey -key $Key -property $Property -value $Value