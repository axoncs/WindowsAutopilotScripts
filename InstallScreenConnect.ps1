#Set Execution Policy
Set-ExecutionPolicy Unrestricted
# Install modules
Install-PackageProvider NuGet -Force
Set-PSRepository PSGallery -InstallationPolicy Trusted
Install-Module -Name Az.Accounts, Az.KeyVault -AllowClobber -Force
#
$vault = "AxonSCVault"
$azure = Get-AzKeyVault -Name $vault -ErrorAction SilentlyContinue
if ($azure) {
	write-host "Already Logged into Azure. Using account"$azure.Account
}else {
    Connect-AzAccount
}
cls
$fqdn = Get-AzKeyVaultSecret -VaultName $vault -Name "FQDN" -AsPlainText
$cwchost = Get-AzKeyVaultSecret -VaultName $vault -Name "Host" -AsPlainText
$port = Get-AzKeyVaultSecret -VaultName $vault -Name "Port" -AsPlainText
$key = Get-AzKeyVaultSecret -VaultName $vault -Name "Key" -AsPlainText
$clientRaw = Read-Host -Prompt "Enter Client's Name"
$client = [uri]::EscapeDataString($clientRaw)

if(($client -eq "") -or ($client -eq $null)) {
    Write-Output "ERROR: The client's name was not provided, skipping ScreenConnect installation."
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
cls
Write-Host "ScreenConnect has been installed successfully. Please Check for $env:COMPUTERNAME under $clientRaw in ScreenConnect."