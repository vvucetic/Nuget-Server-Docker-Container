# Nuget-Server-Docker-Container
Nuget Server hosted in Windows Container

This is implementation of [NuGet Server](https://www.nuget.org/packages/NuGet.Server) package in web application described [here](https://docs.microsoft.com/en-us/nuget/hosting-packages/nuget-server) and delivered in Windows Container.

## Run container

Example usage:

```PowerShell
docker run --name NugetServer -d -p 8080:8080 -v C:/NugetServer/Packages:C:/packages -e API_KEY=**generate_your_key** vvucetic/nuget-server:latest 
```

```PowerShell
docker run --name NugetServer -d -p 80:80 -v C:/NugetServer/Packages:C:/packages -e NUGET_PORT=80 -e API_KEY=**generate_your_key** vvucetic/nuget-server:latest 
```
**Please note that you need to generate API KEY and provide in env variable like in example. And, make sure that NUGET_PORT has the same value as port mapped.**

## Inspect IP of container

With the current release, you can't use http://localhost to browse your site from the container host. This is because of a known behavior in WinNAT, and will be resolved in future. Until that is addressed, you need to use the IP address of the container.

Once the container starts, you'll need to finds its IP address so that you can connect to your running container from a browser. You use the docker inspect command to do that:

```PowerShell
docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" NugetServer,
```

or execute

```PowerShell
start http://$(docker inspect -f '{{ .NetworkSettings.Networks.nat.IPAddress }}' NugetServer):8080
```

to open directly in default browser.