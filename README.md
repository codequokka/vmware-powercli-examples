# vmware-powercli-examples
```
$ curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.3.9/powershell-7.3.9-1.rh.x86_64.rpm -o powershell-7.3.9-1.rh.x86_64.rpm

$ sudo dnf install ./powershell-7.3.9-1.rh.x86_64.rpm

$ pwsh

PS > Install-Module VMware.PowerCLI
PS > Get-Module VMware.PowerCLI -ListAvailable
PS > Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false
PS > Set-PowerCLIConfiguration -InvalidCertificateAction Ignore
```

```
$ /usr/bin/pwsh ./get_alerts.ps1 <vCenter IP address> <vCenter user> <vCenter password> <targetType>
```
