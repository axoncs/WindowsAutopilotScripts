Set-ExecutionPolicy Unrestricted
Install-Module Microsoft.Graph.Beta.DeviceManagement.Enrollment -force
install-script get-windowsautopilotinfo -Force
get-windowsautopilotinfo -online
$allowedAssignmentStatuses = @("assignedInSync", "assignedOutOfSync", "assignedUnkownSyncState")
$autoPilotInfo = get-windowsautopilotinfo
while (($assignmentStatus -eq "") -or ($assignmentStatus -eq $null)) {
    $autoPilotDevice = Get-MgBetaDeviceManagementWindowsAutopilotDeviceIdentity -All | Where-Object SerialNumber -eq $autoPilotInfo."Device Serial Number"
    $assignmentStatus = $autoPilotDevice.DeploymentProfileAssignmentStatus
}
[Console]::Clear()
while ($assignmentStatus -notin $allowedAssignmentStatuses) {
    Write-Host "Device is not assigned yet..."
    $assignmentStatus = (Get-MgBetaDeviceManagementWindowsAutopilotDeviceIdentity -WindowsAutopilotDeviceIdentityId $autoPilotDevice.ID).DeploymentProfileAssignmentStatus
    [Console]::Clear()
}
[Console]::Clear()
Write-Host "Device has been assigned, Rebooting now"
Restart-Computer