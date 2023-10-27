#!/usr/bin/pwsh

param(
    [parameter(mandatory = $true)][string]$Server,
    [parameter(mandatory = $true)][string]$User,
    [parameter(mandatory = $true)][string]$Password,
    [parameter(mandatory = $true)][string]$Datacenter
)

function Connect-Vcenter() {
    param (
        [string]$Server,
        [string]$User,
        [string]$Password
    )
    Connect-VIServer -Server $Server -User $User -Password $Password
}

function Get-AllTriggeredAlarm {
    param (
        [string]$Datacenter
    )
    $alarmOutput = @()

    $entity = Get-Folder -Name $Datacenter

    if ($entity.ExtensionData.TriggeredAlarmState -ne "") {
        foreach ($alarm in $entity.ExtensionData.TriggeredAlarmState) {
            $tempObj = "" | Select-Object -Property Alarm, Entity, EntityMoRef, AlarmStatus, Time, AlarmMoRef
            $tempObj.Entity = Get-View $alarm.Entity | Select-Object -ExpandProperty Name
            $tempObj.Alarm = Get-View $alarm.Alarm | Select-Object -ExpandProperty Info | Select-Object -ExpandProperty Name
            $tempObj.AlarmStatus = $alarm.OverallStatus
            $tempObj.AlarmMoRef = $alarm.Alarm
            $tempObj.EntityMoRef = $alarm.Entity
            $tempObj.Time = $alarm.Time
            $alarmOutput += $tempObj
        }
    }

    return $alarmOutput
}

Connect-Vcenter $Server $User $Password
$triggerdAlarmas = Get-AllTriggeredAlarm $Datacenter
$triggerdAlarmas | Format-Table -AutoSize
