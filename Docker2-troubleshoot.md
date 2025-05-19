# When Things Go Wrong in Docker

## Help! I Can't Create More Containers

One common issue Docker users encounter is running out of space, even when their system appears to have plenty of disk space available. This usually manifests when trying to build or run containers and receiving disk space errors.

### Understanding the Problem

The issue often occurs because:

- Docker images are composed of compressed layers
- On Mac and some Windows installations, Docker engine runs in a virtual machine
- The space limitation might be within the Docker VM, not your host system

### Solutions

1. **Check Current Images**

   ```bash
   docker images
   ```

   This command lists all images, helping you identify unused ones taking up space.

2. **Remove Specific Images**

   ```bash
   docker rmi <image1> <image2> <image3>
   ```

   - Can remove multiple images at once
   - Example: `docker rmi sia/xq nginx selenium/standalone-chrome selenium/standalone-firefox`
   - Note: You might need to stop containers using these images first with `docker rm`
   - Add `-f` flag to force deletion (use with caution due to potential data loss)

3. **Use Docker System Prune**

   ```bash
   docker system prune
   ```

   This command smartly reclaims space by removing:

   - All stopped containers
   - All networks not used by at least one container
   - All dangling images
   - All dangling build cache

   > **Note**: When using this command, you'll receive a warning. You can confirm with lowercase 'y' or abort with uppercase 'N'.
   
   This command can often reclaim significant amounts of space (potentially gigabytes).

### Tips

- Always ensure containers using images are stopped before removing images
- Regular maintenance using `docker system prune` can prevent space issues
- Use `docker rm` to remove stopped containers before removing their images
- Consider using `-f` flag with `docker rmi` only when necessary, being mindful of potential data loss

After implementing these solutions, you should be able to create and run containers again successfully.

## Help! My Container is Really Slow

When containers run slower than expected, there are several powerful commands you can use to diagnose performance issues. Here are three essential troubleshooting commands:

### 1. Docker Stats

The `docker stats` command provides real-time performance metrics for your containers. Here's how to use it:

```bash
docker stats <container_name_or_id>
```

Example usage:

1. First, start a test container:

   ```bash
   docker run --name alpine -d --entrypoint sleep alpine infinity
   ```

2. Monitor its performance:

   ```bash
   docker stats alpine
   ```

This will show you:

- CPU usage percentage
- Memory usage
- Network I/O
- Disk I/O

### 2. Docker Top

The `docker top` command shows the running processes inside a container without having to exec into it:

```bash
docker top <container_name_or_id>
```

This is particularly useful when you want to:

- See what processes are running
- Check if there are unexpected processes
- Monitor resource-intensive tasks

Example:

```bash
docker exec -d alpine sleep 1000
docker exec -d alpine sleep 2000
docker exec -d alpine sleep 3000
docker top alpine
```

### 3. Docker Inspect

The `docker inspect` command provides detailed information about container configuration and runtime state in JSON format:

```bash
docker inspect <container_name_or_id>
```

To make the output more readable, you can pipe it through `less`:

```bash
docker inspect <container_name_or_id> | less
```

Key information you can find with inspect:

- Container restart information
- Mount points and volumes
- Network settings
- Resource limits
- Environment variables
- And much more

### Performance Testing Example

Here's a practical example of using these tools together:

1. Start a container:

   ```bash
   docker run --name alpine -d --entrypoint sleep alpine infinity
   ```

2. Monitor its performance:

   ```bash
   docker stats alpine
   ```

3. In another terminal, simulate high CPU load:

   ```bash
   docker exec -it alpine sh -c "yes > /dev/null"
   ```

4. Observe the spike in CPU usage in the stats output

5. Check running processes:

   ```bash
   docker top alpine
   ```

This example demonstrates how to:

- Monitor container performance
- Generate load for testing
- Observe resource usage changes
- Identify resource-intensive processes

### Tips for Container Performance

- Use `docker stats` for real-time monitoring
- Check process states with `docker top`
- Investigate configuration with `docker inspect`
- Consider using monitoring tools for production environments
- Watch for resource leaks and zombie processes
- Monitor container restart counts for stability issues

## Case Study: Fixing a Broken Container

Let's walk through a practical example of troubleshooting and fixing a problematic container. This case study demonstrates how to use the troubleshooting tools we've learned about.

### The Problem

We have two files:

1. A Dockerfile that builds from an Ubuntu base image
2. A shell script (`app.sh`) that runs our application

### Step 1: Building the Image

First attempt to build:

```bash
docker build -t app .
```

Initial error:

```plaintext
failed to pull image ubuntu:xeniall: not found
```

### Solution Process

1. **Fix the Base Image**
   - Issue: Misspelled `xenial` as `xeniall` in the Dockerfile
   - Solution: Correct the spelling in Dockerfile
   - Search Docker Hub (hub.docker.com) to verify correct image tags

2. **Identify Performance Issues**
   - Build and run the container:

     ```bash
     docker run -it --name app_container app
     ```

   - Observe: Application processing is unusually slow

3. **Investigate with Docker Tools**
   - Use `docker stats` to monitor performance:

     ```bash
     docker stats app_container
     ```

   - Result: High CPU usage detected
   
   - Use `docker top` to check processes:

     ```bash
     docker top app_container
     ```

   - Finding: The `yes` command running repeatedly, causing CPU spikes

4. **Fix the Application Code**
   Original problematic code in `app.sh`:

   ```bash
   process() {
     _process() {
       timeout "$((i*i))" yes &>/dev/null
       echo "Application processing ($1/5)"
     }
     # ...
   }
   ```

   Fix: Remove the CPU-intensive `yes` command

5. **Rebuild and Test**

   ```bash
   docker build -t app .
   docker rm app_container
   docker run -it --name app_container app
   ```

### Key Learnings

1. **Image Problems**

   - Always verify base image names and tags
   - Use Docker Hub to check available versions

2. **Performance Issues**

   - Use `docker stats` to monitor resource usage
   - Use `docker top` to identify problematic processes
   - Look for CPU-intensive operations that might be unnecessary

3. **Container Management**

   - Remove existing containers when names conflict
   - Use the `--rm` flag for temporary containers
   - Monitor container performance in real-time

4. **Debugging Process**

   - Start with building and running
   - Monitor performance metrics
   - Inspect running processes
   - Check application code
   - Test fixes with rebuild

### Best Practices

- Always verify base image names and tags before building
- Monitor container performance during development
- Use Docker's built-in tools (`stats`, `top`, `inspect`) for troubleshooting
- Remove and recreate containers when testing fixes
- Keep container names unique or use the `--rm` flag for temporary containers
