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
