Set-ExecutionPolicy Unrestricted
Install-Module Microsoft.Graph.Beta.DeviceManagement.Enrollment -force
install-script get-windowsautopilotinfo -Force
get-windowsautopilotinfo -online

$autopilotInfo = get-windowsautopilotinfo
$autoPilotDevice = Get-MgBetaDeviceManagementWindowsAutopilotDeviceIdentity -All | Where-Object SerialNumber -eq $autopilotInfo."Device Serial Number"
$assignmentStatus = $autoPilotDevice.DeploymentProfileAssignmentStatus
[Console]::Clear()
while ($assignmentStatus -notin "assignedInSync", "assignedOutOfSync", "assignedUnkownSyncState") {
    Write-Host "Device is not assigned yet..."
    $assignmentStatus = Get-MgBetaDeviceManagementWindowsAutopilotDeviceIdentity -WindowsAutopilotDeviceIdentityId $autoPilotDevice.ID
}
[Console]::Clear()
Write-Host "Device has been assigned, Rebooting now"
Restart-Computer