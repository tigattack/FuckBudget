# FuckBudget

Have you run out of fucks to give? Now you can find out with FuckBudget.

Your fuck budget and a relevant message is randomly generated on each run.

![image](https://user-images.githubusercontent.com/10629864/135592414-3df07e6c-07fc-4489-92ef-f90e5ae4c2b8.png)

## Usage

1. Download files in `module` directory or clone this repository.
2. Open PowerShell in the `module` directory.
3. Run `Import-Module .\`
4. Run `Get-FuckBudget` to retrieve your current fuck budget.

## Overview

* `function/FuckBudget-Function.ps1` - Runs in Azure Functions as an HTTP trigger. Could do with some tidying.
* `module/FuckBudget.psm1` - FuckBudget module. Contains the `Get-FuckBudget` functions.
* `module/FuckBudget.psd1` - FuckBudget module manifest.
