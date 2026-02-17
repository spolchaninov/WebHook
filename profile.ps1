# Azure Functions profile.ps1
#
# This profile.ps1 will get executed every "cold start" of your Function App.
# "cold start" occurs when:
#
# * A Function App starts up for the very first time
# * A Function App starts up after being de-allocated due to inactivity
#
# You can define helper functions, run commands, or specify environment
# variables in this file.

# Authenticate with Azure using the "grafana-webhook" user-assigned managed identity.
Disable-AzContextAutosave -Scope Process | Out-Null
Connect-AzAccount -Identity
