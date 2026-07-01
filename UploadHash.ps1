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
    [Console]::Clear()
    Write-Host "Device is not assigned yet...Checking again in 5 seconds"
    $assignmentStatus = (Get-MgBetaDeviceManagementWindowsAutopilotDeviceIdentity -WindowsAutopilotDeviceIdentityId $autoPilotDevice.ID).DeploymentProfileAssignmentStatus
    Start-Sleep 5
}
[Console]::Clear()
Write-Host "Device has been assigned, Rebooting now"
Start-Sleep 5
Restart-Computer