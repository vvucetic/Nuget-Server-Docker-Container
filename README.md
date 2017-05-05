# Nuget-Server-Docker-Container
Nuget Server hosted in Windows Container

## Run container

```PowerShell
docker run --name NugetServer -d -p 8080:8080 vvucetic/nuget-server:windowsservercore-10.0.14393.1066-v0.1-alpha.2
```
 
## Inspect IP of container

With the current release, you can't use http://localhost to browse your site from the container host. This is because of a known behavior in WinNAT, and will be resolved in future. Until that is addressed, you need to use the IP address of the container.

Once the container starts, you'll need to finds its IP address so that you can connect to your running container from a browser. You use the docker inspect command to do that:

```PowerShell
docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" NugetServer,
```

or

```PowerShell
start http://$(docker inspect -f '{{ .NetworkSettings.Networks.nat.IPAddress }}' NugetServer):8080
```