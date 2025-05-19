# Docker Foundation

## 1. Containers vs Virtual Machines

| Aspect              | Virtual Machines                                   | Containers                                         |
|---------------------|---------------------------------------------------|----------------------------------------------------|
| **Virtualization**  | Hardware-level (hypervisor)                       | OS-level (container runtime)                       |
| **Resource Usage**  | High (full OS per VM)                             | Minimal (shared kernel)                            |
| **Startup Time**    | Slow (seconds-minutes)                            | Fast (milliseconds)                                |
| **Isolation**       | Strong (separate OS)                              | Moderate (shared kernel)                           |
| **Portability**     | Medium (VM-specific)                              | High (standardized)                                |
| **Use Case**        | Full system isolation                             | Application packaging                              |

## 2. Container Architecture

### Key Components

- **Linux Namespaces** - Provides isolated views of system resources
  - PID, Network, Mount, IPC, UTS, User namespaces
- **Control Groups (cgroups)** - Resource limits and monitoring
  - CPU, memory, disk I/O, network bandwidth

## 3. Docker Advantages

### Why Docker Stands Out

- **Simplified Packaging** - Dockerfiles standardize application packaging
- **Ecosystem** - Docker Hub for image sharing and distribution
- **Developer Experience** - Intuitive CLI and tooling
- **Cross-platform** - Consistent environment across development/production

> Historical note: Built on earlier tech (chroot, LXC) but with improved UX

## 4. Docker Alternatives

| Tool             | Key Differentiator                     |
|------------------|----------------------------------------|
| **Podman**       | Rootless, daemonless architecture      |
| **Colima**       | macOS-optimized Docker alternative     |
| **Rancher**      | Kubernetes-focused container platform  |

## 5. Essential Commands

### Basic Operations

```bash
# Version and help
docker --version
docker --help
docker <command> --help

# Container lifecycle
docker run <image>          # Create+start+attach
docker ps                   # List running containers
docker ps -a                # List all containers
docker start/stop <container>
docker rm <container>       # Remove container
docker logs <container>     # View logs
```

### Image Management

```bash
docker pull <image>         # Download image
docker images               # List local images
docker rmi <image>          # Remove image
```

## 6. Container Lifecycle

### Detailed Workflow

1. **Image Pull** (if not local):

   ```bash
   docker pull nginx:alpine
   ```

2. **Container Creation**:

   ```bash
   docker create --name web nginx:alpine
   ```

3. **Container Start**:

   ```bash
   docker start web
   ```

4. **Interaction**:

   ```bash
   docker exec -it web sh   # Get shell
   docker logs web          # View output
   ```

### Understanding docker run

```bash
docker run -d -p 8080:80 --name web nginx:alpine
```

`docker run` is a convenience command that combines three Docker commands into one:

1. `docker pull` (if image not present locally)
2. `docker create` (creates a new container)
3. `docker start` (starts the container)

It also supports additional options like port mapping (`-p`), name assignment (`--name`), and detached mode (`-d`).

## 7. Important Missing Topics

The following key Docker concepts should be added:

1. **Networking**
   - Bridge networks
   - Host networking
   - Custom networks

2. **Storage**
   - Volumes vs bind mounts
   - tmpfs mounts

3. **Multi-stage Builds**
   - Reducing image size
   - Build-time vs runtime dependencies

4. **Docker Compose**
   - Multi-container applications
   - Service definitions

5. **Best Practices**
   - Minimal base images
   - Proper layer caching
   - Security scanning

## 8. Tips & Tricks

- Use partial container IDs (first 3 chars usually sufficient):

  ```bash
  docker logs 4cc   # Instead of full ID
  ```

- Clean up unused resources:

  ```bash
  docker system prune
  ```

- View detailed container info:

  ```bash
  docker inspect <container>
  ```

## 9. Example Dockerfile Analysis (Files/03_05)

Create a Docker container from Dockerfiles, part 1," here are the key takeaways:

Building Docker Images: Learn how to build Docker images from Dockerfiles, which are scripts that contain instructions for creating a Docker image.
Key Dockerfile Commands: Understand important Dockerfile commands such as FROM, USER, COPY, RUN, and ENTRYPOINT, which help in defining the base image, user permissions, copying files, running commands, and setting the default command for the container.
Security Practices: the importance of using non-root users for running commands to enhance security.

example: Files\03_05\Dockerfile

### Dockerfile Breakdown

```dockerfile
FROM ubuntu
- Starts with Ubuntu base image

LABEL maintainer="Carlos Nunez <dev@carlosnunez.me>"
- Metadata about maintainer

USER root
- Runs subsequent commands as root

COPY ./entrypoint.bash /
# Copies entrypoint script into container

RUN apt -y update
RUN apt -y install curl bash
- Updates packages and installs curl/bash

RUN chmod 755 /entrypoint.bash
- Makes entrypoint executable

USER nobody
- Switches to unprivileged user for security

ENTRYPOINT [ "/entrypoint.bash" ]
```

- Sets default command to run entrypoint script

### Entrypoint Script Analysis

The entrypoint.bash script:

1. Checks for bash version 5
2. Verifies curl is installed
3. Gets current date from google.com
4. Prints greeting with current date

### Key Learnings

- Shows multi-stage container setup (root for setup, nobody for runtime)
- Demonstrates proper package installation
- Illustrates entrypoint pattern for container initialization
- Shows security best practices (non-root user)

## Docker Basics

### Building Docker Images

- Use the `docker build` command to create a Docker image from a Dockerfile
- The `-t` option tags the image with a convenient name (e.g., `docker build -t myapp .`)

### Context and Dockerfile

- Docker looks for a file named `Dockerfile` by default in the current directory
- Uses the build context (the folder containing files) to construct the image
- Can specify a different Dockerfile with `-f` flag (e.g., `docker build -f custom.Dockerfile .`)

### Layered Images

- Docker images are built in layers
- Each command in the Dockerfile creates an intermediate image layer
- Layers are cached and reused for faster subsequent builds
- Final image combines all layers into a single immutable artifact

### Running Containers

- After building, run a container with `docker run` followed by the image name
- Common options:
  - `-d` for detached mode (background)
  - `-p` for port mapping (e.g., `-p 8080:80`)
  - `-v` for volume mounts
  - `--name` to assign a container name

## 10. Interacting with Containers (Files/03_06)

### Running Non-Exiting Containers

Unlike previous examples where containers exit immediately after running their entry point commands, some containers (like servers) continue running until explicitly stopped.

#### Building the Container

```bash
docker build -f server.Dockerfile -t our-first-server .
```

#### Running Interactively (Attached)

```bash
docker run our-first-server  # Terminal will attach to container
```

#### Running in Detached Mode

```bash
docker run -d our-first-server  # Runs in background
```

### Managing Running Containers

#### Listing Containers

```bash
docker ps  # Shows running containers
```

#### Stopping Containers

```bash
docker kill <container_id>  # First 4 chars usually sufficient
```

### Interacting with Running Containers

#### Executing Commands

```bash
docker exec <container_id> date  # Runs date command
```

#### Interactive Shell Sessions

```bash
docker exec -it <container_id> bash  # Starts interactive shell
```

The `docker exec` command runs a new command inside a running container. When used with `-i` and `-t` flags, it's particularly useful for getting an interactive shell:

- `-i` or `--interactive`: Keep STDIN open (allows you to type commands)
- `-t` or `--tty`: Allocates a pseudo-TTY (provides a terminal interface)
- `<container_id>`: First few characters of container ID (e.g., "2bf")
- `bash`: The command to run (in this case, starts a bash shell)

For example, `docker exec -i -t 2bf bash` will:

1. Connect to the container with ID starting with "2bf"
2. Start an interactive bash shell session
3. Give you a terminal interface just like SSH-ing into a remote machine

> **Tip:** The `-it` flags are commonly used together and can be combined as one flag: `-it`

### Key Learnings

- Server containers run continuously until stopped
- Use `-d` flag to run containers in background
- `docker exec` allows interaction with running containers
- First few characters of container ID are sufficient for commands
- Interactive shells (`-it`) are useful for debugging

## 11. Stopping and Removing Containers and Images

Managing containers and images is essential to keep your system clean and efficient. Docker does not automatically remove stopped containers or unused images, so manual cleanup is often necessary.

### Stopping Containers

- **Graceful Stop:**

  ```bash
  docker stop <container_id>
  # Example: docker stop 79f6
  ```

  This attempts to gracefully stop the running process inside the container. It may take up to 10 seconds if the application is slow to exit.

- **Forceful Stop:**

  ```bash
  docker stop -t 0 <container_id>
  # Example: docker stop -t 0 79f6
  ```

  The `-t 0` option tells Docker to immediately stop the container. Use with caution, as this can cause data loss.

### Removing Containers

- **Remove a Single Container:**

  ```bash
  docker rm <container_id>
  # Example: docker rm 79f6
  ```

  Note: You cannot remove a running container without the `-f` (force) flag.

- **Force Remove a Running Container:**

  ```bash
  docker rm -f <container_id>
  ```

- **Remove All Stopped Containers (Batch):**

  ```bash
  docker ps -a -q | xargs docker rm
  ```
  
  ```powershell
  docker ps -a -q | ForEach-Object { docker rm $_ }
   ```

  This command lists all container IDs and removes them in one go using `xargs`.

### Removing Images

- **Remove a Single Image:**

  ```bash
  docker rmi <image_name>
  # Example: docker rmi our-server
  ```

  If the image is in use by a running container, stop the container first. Use `-f` to force removal, but be aware this can cause issues if containers depend on the image.

---

**Tip:** Regularly cleaning up unused containers and images helps free disk space and keeps your Docker environment tidy.

> **Warning:** Forceful removal (`-f`) can cause data loss or unpredictable behavior. Always double-check before using it.

`````````
