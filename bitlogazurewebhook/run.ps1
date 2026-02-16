using namespace System.Net

param($Request, $TriggerMetadata)

Write-Information "Request body: $($Request.Body | ConvertTo-Json -Depth 10 -Compress)" -InformationAction Continue

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body       = "OK"
})
