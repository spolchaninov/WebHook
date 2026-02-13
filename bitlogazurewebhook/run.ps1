using namespace System.Net

param($Request, $TriggerMetadata)

# Read expected credentials from app settings
$expectedUsername = $env:BasicAuthUsername
$expectedPassword = $env:BasicAuthPassword

# Get the Authorization header
$authHeader = $Request.Headers["Authorization"]

if (-not $authHeader -or -not $authHeader.StartsWith("Basic ")) {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::Forbidden
        Body       = "Forbidden"
    })
    return
}

# Decode the Base64 credentials from the header
try {
    $encodedCredentials = $authHeader.Substring(6)
    $decodedBytes = [System.Convert]::FromBase64String($encodedCredentials)
    $decodedCredentials = [System.Text.Encoding]::UTF8.GetString($decodedBytes)
    $parts = $decodedCredentials.Split(":", 2)

    $username = $parts[0]
    $password = $parts[1]
}
catch {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::Forbidden
        Body       = "Forbidden"
    })
    return
}

# Validate credentials
if ($username -eq $expectedUsername -and $password -eq $expectedPassword) {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::OK
        Body       = "OK"
    })
}
else {
    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = [HttpStatusCode]::Forbidden
        Body       = "Forbidden"
    })
}
