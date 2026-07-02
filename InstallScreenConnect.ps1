#Set Execution Policy
Set-ExecutionPolicy Unrestricted
Set-PSRepository PSGallery -InstallationPolicy Trusted
# Install Package provider
$nugetProvider = Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue
if ($null -eq $nugetProvider) {
    Write-Host "NuGet provider not found. Installing..." -ForegroundColor Yellow
    Install-PackageProvider -Name NuGet -Force -Confirm:$false -ForceBootstrap
    Write-Host "NuGet provider installed successfully." -ForegroundColor Green
} else {
    Write-Host "NuGet provider is already installed (Version: $($nugetProvider.Version))." -ForegroundColor Green
}
# Install modules
$RequiredModules = @("Az.Accounts", "Az.KeyVault", "AzureAD", "PowerShellGet")
foreach ($Module in $RequiredModules) {
    if (-not (Get-Module -Name $Module -ListAvailable)) {
        Write-Host "Module '$Module' is missing. Installing now..." -ForegroundColor Yellow
        Install-Module -Name $Module -Force -AllowClobber
    } else {
        Write-Host "Module '$Module' is already installed." -ForegroundColor Green
    }
}
#
$vault = "AxonSCVault"
$azure = Get-AzKeyVault -Name $vault -ErrorAction SilentlyContinue
if ($azure) {
	write-host "Already Logged into Azure. Using account"$azure.Account
}else {
    Connect-AzAccount
}
[Console]::Clear()
$fqdn = Get-AzKeyVaultSecret -VaultName $vault -Name "FQDN" -AsPlainText
$cwchost = Get-AzKeyVaultSecret -VaultName $vault -Name "Host" -AsPlainText
$port = Get-AzKeyVaultSecret -VaultName $vault -Name "Port" -AsPlainText
$key = Get-AzKeyVaultSecret -VaultName $vault -Name "Key" -AsPlainText
$clientRaw = Read-Host -Prompt "Enter Client's Name"
$client = [uri]::EscapeDataString($clientRaw)

if(($client -eq "") -or ($client -eq $null)) {
    Write-Host "ERROR: The client's name was not provided, skipping ScreenConnect installation."
}

else {    
    $InstallerName = "ScreenConnect.ClientSetup.msi"
    $InstallerPath = Join-Path $Env:TMP $InstallerName
    $DownloadURL = "https://" + $fqdn + "/Bin/ScreenConnect.ClientSetup.msi?h=" + $cwchost + "&p=" + $port + "&k=" + $key + "&e=Access&y=Guest&t=&c=" + $client + "&c=&c=&c=&c=&c=&c=&c="
    [Net.ServicePointManager]::SecurityProtocol = [Enum]::ToObject([Net.SecurityProtocolType], 3072)
    $WebClient = New-Object System.Net.WebClient
    $WebClient.DownloadFile($DownloadURL, $InstallerPath)
    Start-Process $InstallerPath -wait -ArgumentList '/qn /norestart' -PassThru
} 
[Console]::Clear()
Write-Host "ScreenConnect has been installed successfully. Please Check for $env:COMPUTERNAME under $clientRaw in ScreenConnect."