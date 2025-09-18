# net-triage.ps1
$stamp = (Get-Date -Format 'yyyyMMdd_HHmmss')
$log = "$env:PUBLIC\net_troubleshoot_$stamp.txt"
function Write-Section($name) { "=== $name === $(Get-Date)" | Out-File $log -Append -Encoding utf8 }

Write-Section "PRE"
ipconfig /all | Out-File $log -Append
Get-NetIPConfiguration | Out-File $log -Append
Test-Connection 1.1.1.1 -Count 5 | Out-File $log -Append
Test-NetConnection -ComputerName www.microsoft.com -Port 443 | Out-File $log -Append
Test-NetConnection -ComputerName outlook.office365.com -Port 443 | Out-File $log -Append
route print | Out-File $log -Append

Write-Section "ACTIONS"
"Flushing DNS cache..." | Out-File $log -Append
ipconfig /flushdns | Out-File $log -Append
"Resetting Winsock..." | Out-File $log -Append
netsh winsock reset | Out-File $log -Append
"Resetting TCP/IP..." | Out-File $log -Append
netsh int ip reset | Out-File $log -Append
"Releasing/Renewing DHCP..." | Out-File $log -Append
ipconfig /release | Out-File $log -Append
ipconfig /renew | Out-File $log -Append

Write-Section "POST"
ipconfig /all | Out-File $log -Append
Test-Connection 1.1.1.1 -Count 5 | Out-File $log -Append
Test-NetConnection -ComputerName login.microsoftonline.com -Port 443 | Out-File $log -Append
Test-NetConnection -ComputerName outlook.office365.com -Port 443 | Out-File $log -Append

Write-Section "SUMMARY"
"Log saved to: $log" | Out-File $log -Append
Write-Host "Done. Review log -> $log"
Write-Host "Note: A reboot may be required for Winsock/TCP resets to take effect."
