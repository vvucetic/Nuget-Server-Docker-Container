FROM microsoft/aspnet:4.6.2-windowsservercore-10.0.14393.1066

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

MAINTAINER Vedran Vucetic <vedran.vucetic@gmail.com>
LABEL maintainer "vedran.vucetic@gmail.com"

ENV NS_VERSION="v1.0" 

VOLUME C:\\packages

RUN Write-Host 'Downloading startup.ps1'; \
	Invoke-WebRequest -outfile C:\startup.ps1 "https://raw.githubusercontent.com/vvucetic/Nuget-Server-Docker-Container/master/startup.ps1" -UseBasicParsing;

RUN Write-Host 'Downloading Nuget Server'; \
	Invoke-WebRequest -outfile web.zip "https://github.com/vvucetic/Nuget-Server-Docker-Container/releases/download/$($env:NS_VERSION)/Web.zip" -UseBasicParsing; \
	Write-Host 'Extracting Nuget Server'; \
	Expand-Archive web.zip -DestinationPath C:\NugetServer; \
	Write-Host 'Removing zip'; \
	Remove-Item web.zip;
	
ENTRYPOINT ./startup.ps1