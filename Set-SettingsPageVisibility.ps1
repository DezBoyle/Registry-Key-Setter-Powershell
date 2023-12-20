$Key = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer'
$Property = 'SettingsPageVisibility'
$Value = 'Hide:privacy-location'

Function Test-RegistryValue()
{
    #modified from this broken code snippet https://blog.idera.com/database-tools/test-whether-registry-value-exists
    param
    (
        [string]$regkey,
        [string]$name
    )

    # Write-Host "REGKEY: $regkey, NAME: $name"
    Get-ItemProperty -LiteralPath $regkey -Name $name |
    Out-Null
    $?
}

#does the path exist?  If not, make it
if(-not (Test-Path -Path $Key))
{
    Write-Host "Path: $Key not found, Creating path"
    New-Item -Path $Key -Force
}

#does the key exist?
if(Test-RegistryValue $Key $Property)
{
    #modify the key and return
    Write-Host "Key already exists, setting property"
    Set-ItemProperty -Path $Key -Name $Property -Value $Value
    return
}

#create a new key
try
{
    Write-Host "Creating registry key: $Property"
    New-ItemProperty -Path $Key -Name $Property -Value $Value
}
catch
{
    Write-Error "Failed to create new item property: $Property at path: $Key"
    return
}

Write-Host "Done creating registry key"