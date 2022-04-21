using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

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

# Define fuck messages.
$fuckMessagesZero = @(
    'you have solidly run out of fucks.',
    'you should just give up now.',
    'you''ve truly had enough',
    'it''s time to stop',
    'you should throw your computer away and go live in the woods.',
    'you need to close all tickets, delete the ticketing system, delete the entire infrastructure, and run for the hills.',
    'it''s over, just...stop.'
)

$fuckMessagesMinimal = @(
    'you''re running a little low. You should take the rest of the day off, just to be safe.',
    'you should stop while you''re ahead.',
    'you''d better top up on your fucks.',
    'you''re running a bit low but, if you stop working immediately, you might just get away with it.'
)

$fuckMessagesHigh = @(
    'you''ve got an unexpectedly high amount of fucks left. We''ll look into generating an error report, just to be safe.',
    'you''re doing well! Careful though, each printer fault and password reset can drastically reduce your number of usable fucks.',
    'you can never have too many fucks. It is advised that you take some time out to ensure your usable fucks remain intact.'
)

# Choose relevant fuck message.
$fuckMessage = 'We think that ' + $(
    Switch ($totalUsable) {
        {$_ -gt 5} {Get-Random -InputObject $fuckMessagesHigh}
        {$_ -ge 1} {Get-Random -InputObject $fuckMessagesMinimal}
        {$_ -eq 0} {Get-Random -InputObject $fuckMessagesZero}
        Default {Get-Random -InputObject $fuckMessagesMinimal}
    }
)

# Define output.
$out = @{
    'Budget' = $fuckBudget;
    'TotalUsable' = $totalUsable;
    'FuckMessage' = $fuckMessage
}

# Add usable fucks to output if any are usable.
If ($totalUsable -gt 0) {
    $out += @{'UsableFucks' = $usableFucks}
}

# Set body to JSON of output object.
$body = $out | ConvertTo-Json

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    # Output body with HTTP statuscode.
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
