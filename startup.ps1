Write-Host 'Configuring ApiKey';

$value = "";
if ([System.Environment]::GetEnvironmentVariable("API_KEY", 'Process') -ne $null) {
    $value = [System.Environment]::GetEnvironmentVariable("API_KEY", 'Process')
}
if ([System.Environment]::GetEnvironmentVariable("API_KEY", 'Machine') -ne $null) {
    $value = [System.Environment]::GetEnvironmentVariable("API_KEY", 'Machine')
}
$webConfig = 'C:\NugetServer\Configuration\AppSettings.config'; 
$doc = (Get-Content $webConfig) -as [Xml]; 
$obj = $doc.appSettings.add | where {$_.Key -eq 'apiKey'}; 	
$obj.value = $value; 
Write-Host 'API_KEY Configured: $($obj.value)'; 
$doc.Save($webConfig);

C:\ServiceMonitor.exe w3svc 