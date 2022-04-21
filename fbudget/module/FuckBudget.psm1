function Get-FuckBudget {
	Process {

		# Get fucks
		Try {
			$fucks = (Invoke-WebRequest -Uri 'https://fuckbudget.azurewebsites.net/api/FuckBudget_HttpTrigger').Content | ConvertFrom-Json
		}
		Catch {
			Write-Warning 'Error occurred receiving fuck budget. Please try again later.'
			Throw $_.Exception.Message
		}

		# Output fuck budget
		Try {
			Write-Output "`nFuck Budget:"
			$fucks.Budget | Format-Table FuckID,FuckName,HealthStatus,OperationalStatus,FuckStatus -AutoSize

			# Output list of usable fucks if any
			If ($null -ne $fucks.UsableFucks) {
				Write-Output "Usable Fucks: $(($fucks.UsableFucks) -join ', ')"
			}

			# Output total number of usable fucks
			Write-Output "Total Usable: $($fucks.TotalUsable)"

			# Output fuck message.
			Write-Output "`n$($fucks.FuckMessage)`n"
		}
		Catch {
			Write-Warning 'Error occurred outputting fuck budget.'
			Throw $_.Exception.Message
		}

	}
}
