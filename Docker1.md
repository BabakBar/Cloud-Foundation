# Binding Ports to Your Container

Accessing container network services from your host is a key feature of Docker, made possible through port binding. This allows you to map a port on your computer (the "outside") to a port inside the container (the "inside").

## Why Bind Ports?

By default, containers are isolated and their network ports are not accessible from your host. Port binding lets you access services (like web servers) running inside containers from your browser or other tools on your computer.

## Example: Exposing a Web Server

Suppose you have a Dockerfile named `web-server.Dockerfile` that sets up a simple web server. Here’s how you can build and run it with port binding:

### 1. Build the Image

**Windows PowerShell:**
```powershell
# Build the image from the Dockerfile
# -t gives it a name, -f specifies the Dockerfile
# . is the build context (current directory)
docker build -t our-web-server -f web-server.Dockerfile .
```
**macOS/Linux Bash:**
```bash
docker build -t our-web-server -f web-server.Dockerfile .
```

### 2. Run the Container (No Port Binding Yet)

```powershell
docker run -d --name our-web-server our-web-server
```

Check logs:
```powershell
docker logs our-web-server
```

If the logs say to visit `http://localhost:5000` but it doesn't work, it's because the port isn't mapped to your host yet.

### 3. Remove the Old Container (if needed)

```powershell
docker rm -f our-web-server
```

### 4. Run with Port Binding

To map port 5000 in the container to port 5001 on your host:

**Windows PowerShell:**
```powershell
docker run -d --name our-web-server -p 5001:5000 our-web-server
```
**macOS/Linux Bash:**
```bash
docker run -d --name our-web-server -p 5001:5000 our-web-server
```

- The format is `-p <host_port>:<container_port>`
- Think: **outside:inside** (host:container)

Check that the port is mapped:
```powershell
docker ps
```

You should see a `PORTS` column like `0.0.0.0:5001->5000/tcp`.

Now, visit [http://localhost:5001](http://localhost:5001) in your browser to access the web server running inside the container.

---

> **Tip:** You can use any available port on your host. The container port must match the port your application is listening on inside the container.
> 
> You can name your containers with `--name` for easier management instead of using container IDs.
