using namespace System.Net

param($Request, $TriggerMetadata)

Write-Information "Request body: $($Request.Body | ConvertTo-Json -Depth 10 -Compress)" -InformationAction Continue

# Extract resource name from the first alert's labels
$resourceName = $Request.Body.alerts[0].labels.resourceName
Write-Information "Resource name: $resourceName" -InformationAction Continue

# Map resource name to resource group and subscription ID
$resourceMap = @{
    "bitlog-eu-dev" = @{ ResourceGroup = "Mothership_WE";   SubscriptionId = "a55e60c3-e0ce-4237-b01f-f2ebf555c6b7" }
    "bitlog-eu-stg" = @{ ResourceGroup = "Mothership_WE";   SubscriptionId = "a55e60c3-e0ce-4237-b01f-f2ebf555c6b7" }
    "bitlog-eu-prd" = @{ ResourceGroup = "Mothership_WE";   SubscriptionId = "a55e60c3-e0ce-4237-b01f-f2ebf555c6b7" }
    "bitlog-us-stg" = @{ ResourceGroup = "Mothership_NCUS"; SubscriptionId = "d8e16743-3818-4a60-a9c9-ae4daf8a058c" }
    "bitlog-us-prd" = @{ ResourceGroup = "Mothership_NCUS"; SubscriptionId = "d8e16743-3818-4a60-a9c9-ae4daf8a058c" }
}

if (-not $resourceMap.ContainsKey($resourceName)) {
    Write-Error "Unknown resource name: $resourceName"
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::BadRequest
        Body       = "Unknown resource name: $resourceName"
    })
    return
}

$resourceGroup   = $resourceMap[$resourceName].ResourceGroup
$subscriptionId  = $resourceMap[$resourceName].SubscriptionId

Write-Information "Resource group: $resourceGroup, Subscription ID: $subscriptionId" -InformationAction Continue

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body       = "OK"
})
