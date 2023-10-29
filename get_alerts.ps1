param(
    [parameter(mandatory = $true)]
    [string]$Server,
    [parameter(mandatory = $true)]
    [string]$User,
    [parameter(mandatory = $true)]
    [string]$Password,
    [parameter(mandatory = $true)]
    [ValidateSet("Vcenter", "Datacenter", "VMHost", "VM", "Datastore")]
    [string]$targetType
)

function Connect-Vcenter() {
    param (
        [string]$Server,
        [string]$User,
        [string]$Password
    )
    Connect-VIServer -Server $Server -User $User -Password $Password
}
function Get-Entities {
    param (
        [parameter(mandatory = $true)]
        [ValidateSet("Vcenter", "Datacenter", "VMHost", "VM", "Datastore")]
        [string]$targetType
    )

    switch ($targetType) {
        'vCenter' { $entities = Get-Folder -Name "Datacenters" }
        'Datacenter' { $entities = Get-Datacenter }
        'VMHost' { $entities = Get-VMHost }
        'VM' { $entities = Get-VM }
        'Datastore' { $entities = Get-Datastore }
        default { $entities = $null }
    }

    return $entities
}


function Get-AllTriggeredAlarm {
    param (
        [Object]$entity
    )

    $alarmOutput = @()

    if ($entity.ExtensionData.TriggeredAlarmState -ne "") {
        foreach ($alarm in $entity.ExtensionData.TriggeredAlarmState) {
            $tempObj = "" | Select-Object -Property AlarmName, Object, ObjectType, Severity, TriggeredTime, AcknowledgedTime, AcknowledgedBy
            $tempObj.AlarmName = Get-View $alarm.Alarm | Select-Object -ExpandProperty Info | Select-Object -ExpandProperty Name
            $tempObj.Object = Get-View $alarm.Entity | Select-Object -ExpandProperty Name
            $tempObj.ObjectType = $alarm.Entity.Type
            $tempObj.Severity = $alarm.OverallStatus
            $tempObj.TriggeredTime = $alarm.Time
            $tempObj.AcknowledgedTime = $alarm.AcknowledgedTime
            $tempObj.AcknowledgedBy = $alarm.AcknowledgedByUser
            $alarmOutput += $tempObj
        }
    }

    return $alarmOutput
}

Connect-Vcenter $Server $User $Password
$entities = Get-Entities $targetType
foreach ($entity in $entities) {
    Get-AllTriggeredAlarm $entity | Format-Table -AutoSize
}
