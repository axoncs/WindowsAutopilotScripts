$appVersion ="0.1"
$serialNumber = (Get-CimInstance Win32_BIOS | Select-Object SerialNumber).SerialNumber
$logo=@"
                                 ###    ##     ##  #######  ##    ## 
                                ## ##    ##   ##  ##     ## ###   ##      Serial: $serialNumber
                               ##   ##    ## ##   ##     ## ####  ##      Hostname: $env:COMPUTERNAME
                              ##     ##    ###    ##     ## ## ## ## 
                              #########   ## ##   ##     ## ##  #### 
                              ##     ##  ##   ##  ##     ## ##   ### 
                              ##     ## ##     ##  #######  ##    ## 
  _   _                 _____   _____    _____      _                __          ___                  _ 
 | \ | |               |  __ \ / ____|  / ____|    | |               \ \        / (_)                | |
 |  \| | _____      __ | |__) | |      | (___   ___| |_ _   _ _ __    \ \  /\  / / _ ______ _ _ __ __| |
 | . ` |/ _ \ \ /\ / / |  ___/| |       \___ \ / _ \ __| | | | '_ \    \ \/  \/ / | |_  / _` | '__/ _` |
 | |\  |  __/\ V  V /  | |    | |____   ____) |  __/ |_| |_| | |_) |    \  /\  /  | |/ / (_| | | | (_| |
 |_| \_|\___| \_/\_/   |_|     \_____| |_____/ \___|\__|\__,_| .__/      \/  \/   |_/___\__,_|_|  \__,_|
                                                             | |                                        
                                                             |_|  v$appVersion   
"@
[Console]::Clear()
Write-Host $logo -ForegroundColor Cyan
write-host "Deploying ScreenConnect to $env:COMPUTERNAME. Please login next with your Axon Azure Account to begin the Installation Process."
Write-Host "iex (irm a.xon.ac/sc)"
Write-Host "You can now connect via ScreenConnect."
pause
[Console]::Clear()
Write-Host $logo -ForegroundColor Cyan
write-host "Uploading details for $env:COMPUTERNAME to AutoPilot. Please login next with the tenant admin, or an account with sufficient privileges to begin the process."
Write-Host "iex (irm a.xon.ac/1)"