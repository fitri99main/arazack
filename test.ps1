try {
    $Url = "https://lmgzsfivhdoczbgoshyu.supabase.co/rest/v1/site_data"
    $Key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxtZ3pzZml2aGRvY3piZ29zaHl1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg5NjU2NTQsImV4cCI6MjA5NDU0MTY1NH0.RxEztkIUOMtPDk90PrLbiKCitGA-5GlXAWWxiMxd36I"
    $Body = @{ "key" = "test"; "value" = @{"hello" = "world"} } | ConvertTo-Json
    $Response = Invoke-WebRequest -Uri $Url -Method Post -Headers @{"apikey"=$Key; "Authorization"="Bearer $Key"; "Content-Type"="application/json"} -Body $Body
    Write-Output "SUCCESS:"
    Write-Output $Response.Content
} catch {
    Write-Output "ERROR:"
    Write-Output $_.Exception.Response
    $stream = $_.Exception.Response.GetResponseStream()
    $reader = New-Object System.IO.StreamReader($stream)
    Write-Output $reader.ReadToEnd()
}
