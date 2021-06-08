function Get-FuckBudget {
	$fuckBudget = @()
	foreach ($fuck in 0..9) {
		# Define values
		$fuckName = "Fuck $(([string]$fuck).PadLeft(2,'0'))"
		$fuckHealth = Get-Random -InputObject $('Healthy','Warning','Failed','Unknown')
		$fuckOper = Get-Random -InputObject $('Online','Offline')
		$fuckStatus = Get-Random -InputObject $('Ready','Expired')

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
	$usableFucks = ($fuckBudget | Where-Object {$_.HealthStatus -eq 'Healthy' -and $_.OperationalStatus -eq 'Online' -and $_.FuckStatus -eq 'Ready'}).FuckName

	# Output all fucks
	$fuckBudget | Format-Table FuckID,FuckName,HealthStatus,OperationalStatus,FuckStatus -AutoSize

	# List usable fucks
	If ($usableFucks.Count -gt 0) {Write-Output "Usable fucks: $($usableFucks -join ', ')"}

	# Count usable fucks
	Write-Output "Total usable: $($usableFucks.Count)"
}
