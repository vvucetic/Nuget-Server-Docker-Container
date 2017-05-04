FROM microsoft/aspnet:4.6.2-windowsservercore-10.0.14393.1066

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

MAINTAINER Vedran Vucetic <vedran.vucetic@gmail.com>
LABEL maintainer "vedran.vucetic@gmail.com"

ENV NS_VERSION="v0.1-alpha.2" 

RUN Write-Host 'Downloading ServerMonitor'; \
	Invoke-WebRequest -outfile C:\ServiceMonitor.exe "https://github.com/Microsoft/iis-docker/blob/master/windowsservercore/ServiceMonitor.exe?raw=true" -UseBasicParsing;

RUN Write-Host 'Downloading Nuget Server'; \
	Invoke-WebRequest -outfile web.zip "https://github.com/vvucetic/Nuget-Server-Docker-Container/releases/download/$($env:NS_VERSION).zip" -UseBasicParsing; \
	Write-Host 'Extracting Nuget Server'; \
	Expand-Archive web.zip -DestinationPath C:\NugetServer; \
	Write-Host 'Removing zip'; \
	Remove-Item web.zip; \
	Write-Host 'Creating IIS site'; \
	Import-module IISAdministration; \
	New-IISSite -Name "NugetServer" -PhysicalPath C:\NugetServer -BindingInformation "*:8080:";

EXPOSE 8080
	
ENTRYPOINT ["C:\ServiceMonitor.exe ", "w3svc"]