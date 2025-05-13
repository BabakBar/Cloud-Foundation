# Docker Foundation

## Containers vs. Virtual Machines

| Aspect              | Virtual Machines                                   | Containers                                         |
|---------------------|---------------------------------------------------|----------------------------------------------------|
| **Virtualization**  | Virtualizes hardware using a hypervisor           | Virtualizes OS kernel using container runtimes     |
| **Resource Usage**  | Requires more disk space (emulated memory/disks)  | Lightweight, uses less disk space                  |
| **Startup Time**    | Slower (needs to boot up an OS)                   | Fast (no OS boot required)                         |
| **Security**        | Strong isolation, separate OS per VM              | Shares host OS, some security concerns (mostly resolved) |

---

## The Anatomy of a Container

- **Components:**
  - **Linux Namespace:** Provides isolated views of the system for each container (all except TIME namespace used by Docker).
  - **Linux Control Group (cgroup):** Restricts and monitors hardware resources (CPU, memory, network bandwidth) for each process.

---

## The Docker Difference

- **Historical Context:**
  - Docker is not the first container technology (predecessors: Chroot, BSD Jails, Solaris Zones, LXC).
- **Ease of Use:**
  - Dockerfiles make it easy to package applications and environments into images.
- **Image Sharing:**
  - Docker Hub enables global sharing of images; alternative registries are available.
- **User-Friendly CLI:**
  - The Docker CLI simplifies container management without complex configuration.

> These points highlight why Docker is a popular choice for containerization.

---

## Docker Main Alternatives

- Colima
- Rancher Desktop
- Podman

---

## Useful Commands

```sh
docker --version         # Check Docker version
docker ps                # List running containers
docker run hello-world   # Run a test container
docker --help            # Get help for Docker CLI
# You can run help for any command:
docker network --help
```

---

## Creating and Managing Docker Containers

### Creating Containers

- **Command:**

  ```sh
  docker container create <image>:<tag>
  ```

  - If the image is not available locally, Docker will automatically pull it from Docker Hub.
  - Example:

    ```sh
    docker container create hello-world:linux
    ```

    Output:

    ```
    Unable to find image 'hello-world:linux' locally
    linux: Pulling from library/hello-world
    Digest: sha256:a77ecd852b17bfaee6708208960645d20fc9e6d0eec12353f8eb0e7b94bb647a
    Status: Downloaded newer image for hello-world:linux
    4cc89b1f11d9b553ba6fb682653385e85f44ef54ca1701476d7ec845eece8e53
    ```

  - The last line is the **container ID** (unique identifier for the container).

### Listing Containers

- **List running containers:**

  ```sh
  docker ps
  ```

- **List all containers (including stopped):**

  ```sh
  docker ps --all
  ```

### Starting Containers

- **Start a container by ID:**

  ```sh
  docker container start <container_id>
  ```

  - Example:

    ```sh
    docker container start 4cc89b1f11d9b553ba6fb682653385e85f44ef54ca1701476d7ec845eece8e53
    ```

- **Start and attach to a container (see output in terminal):**

  ```sh
  docker container start --attach <container_id>
  ```

  - If you omit the container ID, Docker will show a usage message.

### Viewing Container Logs

- **Show logs for a container:**

  ```sh
  docker logs <container_id>
  ```

  - Example output for `hello-world`:

    ```
    Hello from Docker!
    This message shows that your installation appears to be working correctly.
    ...
    ```

#### What Happens When You Create and Start a Container?

1. Docker checks for the image locally; if not found, it pulls from Docker Hub.
2. Docker creates a new container from the image, assigning a unique container ID.
3. When started, the container runs its default command (e.g., `/hello` for `hello-world`).
4. You can view the output using `docker logs` or by attaching to the container.

---
