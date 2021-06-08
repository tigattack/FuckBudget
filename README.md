# FuckBudget
Have you run out of fucks to give? Now you can find out with FuckBudget.  
Your fuck budget is randomly generated on each run.

## Overview

`function.ps1` - Runs in Azure Functions as an HTTP trigger. Could do with some tidying.  
`FuckBudget/FuckBudget.psm1` - FuckBudget module. Currently contains only the `Get-FuckBudget` function.  
`FuckBudget/FuckBudget.psd1` - FuckBudget module manifest.  

`Get-FuckBudget_old.ps1` - Original implementation. Runs locally.

## Usage

1. Download files in `FuckBudget` directory or clone this repository.
2. Open PowerShell in the `FuckBudget` directory.
3. Run `Import-Module .\`
4. Run `Get-FuckBudget` to see your fuck budget.
