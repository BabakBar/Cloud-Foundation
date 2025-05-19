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

> You can name your containers with `--name` for easier management instead of using container IDs.

## Saving Data from Containers

Containers are designed to be disposable. When a container is deleted, any data stored inside it is lost. This is important to remember if your application needs to save data after the container stops.

### Example: Data Loss in Ephemeral Containers

Let's see what happens when we create a file inside a container and then remove the container:

**Windows PowerShell:**

```powershell
docker run --rm --entrypoint sh ubuntu -c "echo 'Hello there.' > /tmp/file && cat /tmp/file"
```

- This command runs a temporary Ubuntu container, writes 'Hello there.' to `/tmp/file`, and prints it.
- The `--rm` flag removes the container after it exits.

If you try to access `/tmp/file` on your host, it won't exist. Everything created inside the container is deleted with it.

### Persisting Data with Volumes

To keep data after a container stops, use Docker's **volume mounting** feature. This maps a folder (or file) on your computer to a folder (or file) inside the container.

- The format is `-v <host_path>:<container_path>`
- Think: **outside:inside** (host:container)

#### Example: Mapping a Host Folder

**Windows PowerShell:**

```powershell
docker run --rm --entrypoint sh -v C:/tmp/container:/tmp ubuntu -c "echo 'Hello there.' > /tmp/file && cat /tmp/file"
```

- This maps `C:/tmp/container` on your computer to `/tmp` in the container.
- After the command runs, check for the file on your host:

```powershell
cat C:/tmp/container/file
```

You should see `Hello there.` printed on your host.

#### Example: Mapping a Host File

1. Create a file on your host:

    ```powershell
    ni C:/tmp/change_this_file -ItemType File
    ```

2. Run the container, mapping the file:

    ```powershell
    docker run --rm --entrypoint sh -v C:/tmp/change_this_file:/tmp/file ubuntu -c "echo 'Changed!' > /tmp/file"
    ```

3. Check the file on your host:

    ```powershell
    cat C:/tmp/change_this_file
    ```

**Note:** If you map a file that does not exist on your host, Docker will create a directory instead of a file. Always ensure the file exists before mapping.

---

> **Tip:** Use volume mounting to persist important data, such as database files or uploads, outside your containers. This makes your containers truly disposable and your data safe.

## Pushing Images to the Docker Registry

Docker Hub is a public registry where you can store and share your Docker images. To push an image to Docker Hub, follow these steps:

### 1. Create a Docker Hub Account

- Go to [Docker Hub](https://hub.docker.com/) and click **Register** in the upper right.
- Fill in your information and choose a strong password.
- Save your username and password securely.
- Verify your email address by clicking the link sent to your inbox.

### 2. Log In to Docker Hub from the CLI

Use the Docker CLI to log in:

```powershell
docker login
```

- Enter your Docker Hub username and password when prompted.
- You should see a message: `Login Succeeded`.

### 3. Tag Your Image for Docker Hub

Docker images must be named with your Docker Hub username to push them. Use the `docker tag` command:

```powershell
docker tag our-web-server <your-username>/our-web-server:0.0.1
```

- Replace `<your-username>` with your Docker Hub username.
- The `:0.0.1` is a version tag. You can use any versioning scheme you like.

### 4. Push the Image to Docker Hub

Now push your tagged image:

```powershell
docker push <your-username>/our-web-server:0.0.1
```

- You'll see upload progress and confirmation when the push is complete.

---

> **Tip:** Use version tags (like `:0.0.1`) to keep track of different versions of your images. Avoid using only `:latest` for everything.

> **Security:** Store your Docker Hub credentials securely, such as in a password manager.
