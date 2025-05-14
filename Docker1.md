# Binding Ports to Your Container

Accessing services running inside your Docker containers from your host machine is possible through port binding. This allows you to map a port on your computer (the "outside") to a port inside the container (the "inside").

## Building the Web Server Image

First, build the image using the provided Dockerfile:

**PowerShell (Windows):**
```powershell
docker build -t our-web-server -f web-server.Dockerfile .
```
**Bash (macOS/Linux):**
```bash
docker build -t our-web-server -f web-server.Dockerfile .
```

## Running the Container with Port Binding

To run the container in the background and give it a name:

**PowerShell (Windows):**
```powershell
docker run -d --name our-web-server our-web-server
```
**Bash (macOS/Linux):**
```bash
docker run -d --name our-web-server our-web-server
```

Check that it’s running:

**PowerShell (Windows):**
```powershell
docker ps
```
**Bash (macOS/Linux):**
```bash
docker ps
```

Check the logs for instructions:

**PowerShell (Windows):**
```powershell
docker logs our-web-server
```
**Bash (macOS/Linux):**
```bash
docker logs our-web-server
```

If the server tells you to visit `http://localhost:5000` but it doesn’t work, it’s because you haven’t mapped the port yet.

## Stopping and Removing the Container

You can stop and remove the container in one step:

**PowerShell (Windows):**
```powershell
docker rm -f our-web-server
```
**Bash (macOS/Linux):**
```bash
docker rm -f our-web-server
```

## Mapping Ports: Outside : Inside

To map a port from your host (e.g., 5001) to the container’s port (e.g., 5000):

**PowerShell (Windows):**
```powershell
docker run -d --name our-web-server -p 5001:5000 our-web-server
```
**Bash (macOS/Linux):**
```bash
docker run -d --name our-web-server -p 5001:5000 our-web-server
```

- The format is `-p <host_port>:<container_port>`
- Think: **outside:inside** (host:container)

Check that the port is mapped:

**PowerShell (Windows):**
```powershell
docker ps
```
**Bash (macOS/Linux):**
```bash
docker ps
```

You should see a `PORTS` column showing `0.0.0.0:5001->5000/tcp`.

Now, visit [http://localhost:5001](http://localhost:5001) in your browser to access the service running inside the container.

---

> **Tip:** You can use any available port on your host. The container port must match the port your application is listening on inside the container.
