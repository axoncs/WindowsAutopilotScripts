# Set TLS 1.2 as the default security protocol
IF([Net.SecurityProtocolType]::Tls12) {[Net.ServicePointManager]::SecurityProtocol=[Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12}
#Set Execution Policy
Set-ExecutionPolicy Unrestricted
# Install modules
$RequiredModules = @("Microsoft.Graph.Beta.DeviceManagement.Enrollment", "WindowsAutopilotIntune")
foreach ($Module in $RequiredModules) {
    if (-not (Get-Module -Name $Module -ListAvailable)) {
        Write-Host "Module '$Module' is missing. Installing now..." -ForegroundColor Yellow
        Install-Module -Name $Module -Force -AllowClobber
    } else {
        Write-Host "Module '$Module' is already installed." -ForegroundColor Green
    }
}
install-script get-windowsautopilotinfo -Force
get-windowsautopilotinfo -online
#adding both assignedUnkownSyncState and assignedUnknownSyncState in case M$ fixes the spelling one day REF: https://learn.microsoft.com/en-us/graph/api/resources/intune-enrollment-windowsautopilotprofileassignmentstatus?view=graph-rest-beta
$allowedAssignmentStatuses = @("assignedInSync", "assignedOutOfSync", "assignedUnknownSyncState", "assignedUnkownSyncState")
$autoPilotInfo = get-windowsautopilotinfo
while (($assignmentStatus -eq "") -or ($assignmentStatus -eq $null)) {
    $autoPilotDevice = Get-MgBetaDeviceManagementWindowsAutopilotDeviceIdentity -All | Where-Object SerialNumber -eq $autoPilotInfo."Device Serial Number"
    $assignmentStatus = $autoPilotDevice.DeploymentProfileAssignmentStatus
}
[Console]::Clear()
while ($assignmentStatus -notin $allowedAssignmentStatuses) {
    [Console]::Clear()
    Write-Host "Device is not assigned yet...Checking again in 5 seconds."
    $assignmentStatus = (Get-MgBetaDeviceManagementWindowsAutopilotDeviceIdentity -WindowsAutopilotDeviceIdentityId $autoPilotDevice.ID).DeploymentProfileAssignmentStatus
    Start-Sleep 5
}
[Console]::Clear()
Write-Host "Device has been assigned, Rebooting in 5 seconds to continue Autopilot process."
Start-Sleep 5
Restart-Computer