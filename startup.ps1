Write-Host 'Stop the default web site';
Stop-IISSite -Name 'Default Web Site' -Confirm:$false

$Port = 8080
if (![string]::IsNullOrEmpty($env:NUGET_PORT)) { $Port = $env:NUGET_PORT }

Write-Host 'Creating IIS site';
Import-module IISAdministration;
New-IISSite -Name "NugetServer" -PhysicalPath C:\NugetServer -BindingInformation "*:$Port:";
icacls C:\packages /grant 'IIS AppPool\DefaultAppPool:(OI)(CI)M';

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