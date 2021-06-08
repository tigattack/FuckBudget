using namespace System.Net

# Input bindings are passed in via param block.
#param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Output "PowerShell HTTP trigger function processed a request."

$fuckBudget = @()
foreach ($fuck in 0..9) {
    # Define values
    $fuckName = "Fuck $(([string]$fuck).PadLeft(2,'0'))"
    $fuckHealth = Get-Random -InputObject $('Healthy','Warning','Failed','Unknown')
    If ($fuckHealth -match 'Failed|Unknown') {
        $fuckOper = 'Offline'
        $fuckStatus = 'Expired'
    }
    else {
        $fuckOper = Get-Random -InputObject $('Online','Offline')
        $fuckStatus = Get-Random -InputObject $('Ready','Expired')
    }

    # Define obj
    $fucks = @{
        'FuckID' = $fuck;
        'FuckName' = $fuckName;
        'HealthStatus' = $fuckHealth;
        'OperationalStatus' = $fuckOper;
        'FuckStatus' = $fuckStatus
    }
    $object = New-Object –TypeName PSObject –Property $fucks
    $fuckBudget += $object
}
# Find usable fucks
$usableFucks = ($fuckBudget | Where-Object {$_.HealthStatus -match 'Healthy|Warning' -and $_.OperationalStatus -eq 'Online' -and $_.FuckStatus -eq 'Ready'}).FuckName
$totalUsable = $usableFucks.Count

$out = @{
    'Budget' = $fuckBudget;
    'Total Usable' = $totalUsable
}
If ($totalUsable -gt 0) {$out += @{'Usable fucks' = $usableFucks}}

$body = $out | ConvertTo-Json

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
