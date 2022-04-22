# ZIP function file(s)
data "archive_file" "file_function_app" {
  type        = "zip"
  source_dir  = "../function"
  output_path = "function.zip"
}

# Define command to publish code to Azure Functions
locals {
    publish_code_command = "az webapp deployment source config-zip --resource-group ${azurerm_resource_group.group.name} --name ${azurerm_windows_function_app.FuckBudget.name} --src ${data.archive_file.file_function_app.output_path}"
    rm_command = "rm -f ${data.archive_file.file_function_app.output_path}"
}


# Define resource group
resource "azurerm_resource_group" "group" {
  location = "ukwest"
  name     = "FuckBudget_RG"
}

# Define storage account for function app
# resource "azurerm_storage_account" "storage" {
resource "azurerm_storage_account" "storage" {
  depends_on = [azurerm_resource_group.group]

  name                     = "fuckbudgetsa"
  resource_group_name      = azurerm_resource_group.group.name
  location                 = azurerm_resource_group.group.location

  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
}

# Define service plan for function app
resource "azurerm_service_plan" "asp" {
  depends_on = [azurerm_resource_group.group]

  name                = "FuckBudget_SP"
  location            = azurerm_resource_group.group.location
  resource_group_name = azurerm_resource_group.group.name

  os_type = "Windows"
  sku_name = "Y1"
}

# Define function app
resource "azurerm_windows_function_app" "FuckBudget" {
  depends_on = [
    azurerm_resource_group.group,
    azurerm_storage_account.storage,
    azurerm_service_plan.asp,
  ]

  name                = "FuckBudget"
  resource_group_name = azurerm_resource_group.group.name
  location            = azurerm_resource_group.group.location

  storage_account_name = azurerm_storage_account.storage.name
  service_plan_id      = azurerm_service_plan.asp.id

  builtin_logging_enabled = true
  client_certificate_mode = "Optional"
  functions_extension_version = "~3"
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = "1",
  }

  site_config {
    ftps_state = "Disabled"
    scm_minimum_tls_version = "1.2"
    application_stack {
      powershell_core_version = "7"
    }
  }
}

# Push code to storage
resource "null_resource" "function_app_publish" {
  provisioner "local-exec" {
    command = local.publish_code_command
  }
  depends_on = [local.publish_code_command]
  triggers = {
    input_json = filemd5(data.archive_file.file_function_app.output_path)
    publish_code_command = local.publish_code_command
  }
}

# Output function app URL
locals {
  function_spec = jsondecode(file("${path.module}/../function/budget/function.json"))
}
output "function_app_url" {
  value = "https://${azurerm_windows_function_app.FuckBudget.name}.azurewebsites.net/api/${local.function_spec.bindings[0].route}"
}
