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

## Checking Your Images in Docker Hub

After pushing your image to Docker Hub, you can verify and manage it through the Docker Hub website.

### 1. View Your Image in Docker Hub

- Go to [Docker Hub](https://hub.docker.com/) and sign in.
- On your dashboard, you'll see a list of your repositories (images).
- Click on your image (e.g., `our-web-server`) to view its details.
- Here, you can see all the tags you've pushed, the compatible operating systems, and the last push date.
- If you have many tags, click **See all** to view them.

### 2. Pushing a New Tag

You can push additional tags for the same image. For example, to add a new version:

```powershell
docker tag our-web-server <your-username>/our-web-server:0.0.2

docker push <your-username>/our-web-server:0.0.2
```

- Docker will only upload new layers if the image has changed. If not, the push will be very fast.
- Refresh your Docker Hub repository page to see the new tag appear.

### 3. Deleting an Image or Repository

If you want to remove an image or repository:

- This must be done from the Docker Hub website (not the CLI).
- Go to your repository, click **Settings**, then **Delete repository**.
- When prompted, enter only the repository name (e.g., `our-web-server`), not the full tag.
- Confirm the deletion. The repository and all its tags will be removed.

---

> **Tip:** Use tags to manage different versions of your images. Delete test images from Docker Hub to keep your account organized.

## Challenge: Starting NGINX

In this challenge, you'll use Docker to serve a real website using the official NGINX image. The goal is to make the website accessible at [http://localhost:8080](http://localhost:8080) and ensure the container is removed after use.

### Steps

1. **Navigate to the correct folder**

   Make sure you are in the `03_14` folder, which contains the `website` directory:

   ```powershell
   cd Files/03_14_before
   ```

2. **Run the NGINX container with volume mount and port mapping**

   Use the following command to start the container:

   ```powershell
   docker run --rm -d --name website -p 8080:80 -v ${PWD}/website:/usr/share/nginx/html nginx
   ```

   - `--rm` removes the container after it stops.
   - `-d` runs the container in detached mode.
   - `--name website` names the container for easy management.
   - `-p 8080:80` maps port 8080 on your host to port 80 in the container.
   - `-v ${PWD}/website:/usr/share/nginx/html` mounts the local `website` folder to the NGINX web root.

3. **View the website**

   Open your browser and go to [http://localhost:8080](http://localhost:8080) to see the website served by NGINX.

4. **Stop and remove the container**

   When you're done, stop the container:

   ```powershell
   docker stop website
   ```

   Since you used `--rm`, the container will be removed automatically.

---

> **Tip:** Using `--rm` ensures your container is cleaned up after use. Volume mounts let you serve static content directly from your project folder.

### Solution: Starting NGINX

Let's work through solving this challenge step by step.

1. **Understanding the Requirements**
   - Use the official NGINX image from Docker Hub (no Dockerfile needed)
   - Name the container "website"
   - Make the site accessible at [http://localhost:8080](http://localhost:8080)
   - Use volume mounting for the static site
   - Container should delete itself after stopping

2. **Building the Docker Command**

   Let's break down the command piece by piece:

   ```powershell
   docker run --name website -v "${PWD}/website:/usr/share/nginx/html" -p 8080:80 --rm nginx
   ```

   - `docker run`: Start a new container
   - `--name website`: Name the container "website"
   - `-v "${PWD}/website:/usr/share/nginx/html"`: Mount our local website folder
     - `${PWD}/website` is the outside (host) path
     - `/usr/share/nginx/html` is the inside (container) path
     - Quotes around the volume mount help prevent path issues
   - `-p 8080:80`: Map ports
     - `8080` is the outside (host) port
     - `80` is the inside (container) port where NGINX serves
   - `--rm`: Remove the container when it stops
   - `nginx`: The official NGINX image from Docker Hub

3. **Verifying the Container**

   After running the container and viewing the website, you can check its status:

   ```powershell
   docker ps -a
   ```

   - The `-a` flag shows all containers, including stopped ones
   - If using `--rm`, the container won't appear after stopping

4. **Common Issues and Solutions**
   - If the volume mount fails, try using quotes around the path
   - If the website doesn't load, check that your ports match (8080:80)
   - No need to modify NGINX configuration for basic static sites

Congratulations! You've successfully served a static website using Docker and NGINX. This pattern is commonly used in development environments and for serving static content in production.

---

> **Tip:** The `--rm` flag is useful during development to keep your system clean, but in production, you might want to keep containers around for logging and debugging.
