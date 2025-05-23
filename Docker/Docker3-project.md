# Writing a Dockerfile

A Dockerfile is a text file that contains instructions for building a Docker image. It allows you to define a reproducible environment for your application, regardless of the language or framework (Python, Go, Node.js, etc.).

Below are common Dockerfile instructions and their purposes, applicable to a wide range of projects:

- `FROM <base-image>`
  - Specifies the base image for your container. This could be a language runtime (e.g., `python:3.12`, `golang:1.21`, `node:20`), a minimal OS, or even `scratch` for custom builds.
- `WORKDIR <directory>`
  - Sets the working directory inside the container. All subsequent instructions will be run from this directory.
- `COPY <src> <dest>`
  - Copies files and directories from your project into the container. This is how you include your application code and resources.
- `RUN <command>`
  - Executes commands in the container during the build process. Commonly used to install dependencies (e.g., `pip install`, `go build`, `npm install`).
- `ENV <key>=<value>`
  - Sets environment variables inside the container. Useful for configuration, such as specifying the main application file or runtime options.
- `EXPOSE <port>`
  - Documents which port the application will listen on. (Note: This does not actually publish the port.)
- `CMD ["executable", "param1", ...]` or `CMD "command param1 ..."`
  - Sets the default command to run when the container starts. For example, launching a web server or application process.
- `ENTRYPOINT ["executable", "param1", ...]`
  - Sets the main command for the container, often used in combination with `CMD` for more control.

---

## Building a Docker Image from a Dockerfile

To build a Docker image, use the `docker build` command in your terminal. This command reads the instructions from your Dockerfile and creates an image based on those steps.

**Basic Syntax:**

```
docker build [options] <path>
```

- `<path>` is the build context (usually `.` for the current directory).

**Common Options:**

- `-f <dockerfile>`: Specify a different Dockerfile (useful for multiple environments like QA, staging, production).
- `--force-rm=true`: Remove intermediate containers after a successful or failed build (helps keep things clean).
- `--rm=false`: Keep intermediate containers if the build fails (useful for debugging).
- `--no-cache`: Build the image without using cache (forces all steps to run fresh; use if you suspect cache issues).

**Typical Command:**

```
docker build .
```

This builds the image using the Dockerfile in the current directory and the current directory as the build context.

**Example with options:**

```
docker build --force-rm=true -f Dockerfile .
```

**Tips:**

- The build context includes all files in the specified path, so avoid including unnecessary files (use `.dockerignore`).
- Use `docker build --help` to see all available options.
- For CI/CD, you can build from a remote repository URL as the context.

By understanding these options, you can efficiently build, debug, and manage Docker images for any environment.

---

## Searching for Images in Docker Hub

When writing a Dockerfile, you often need to choose a base image. Docker Hub (https://hub.docker.com) is the main public registry for container images. You can search for images directly from the command line using the `docker search` command.

**Basic Syntax:**

```sh
docker search <image-name>
```

**Example:**

```sh
docker search python
```

This returns a list of available Python images, including their names, descriptions, number of stars (popularity), and whether they are official or automated builds.

**Useful Options:**

- `--filter "is-official=true"` : Show only official images.
- `--filter "is-automated=true"` : Show only automated builds.
- `--filter "stars=100"` : Show images with at least 100 stars.
- `--limit <number>` : Limit the number of results.
- `--no-trunc` : Show full output without truncating descriptions.
- `--format` : Format the output using a Go template (e.g., to show only names and descriptions).

**Examples:**

Show only official Python images:

```sh
docker search python --filter "is-official=true"
```

Show Python images with at least 100 stars:

```sh
docker search python --filter "stars=100"
```

Show top 4 Python images:

```sh
docker search python --limit 4
```

Show full descriptions:

```sh
docker search python --no-trunc
```

**Tips:**

- Use multiple `--filter` options to combine filters.
- Use the Docker Hub website to browse images and see all available tags (versions).
- Avoid using the `latest` tag in production; specify a version for stability.
- Pull an image with `docker pull <image>:<tag>` (e.g., `docker pull python:3.12`).

By mastering Docker Hub search and image selection, you can find the best and most secure base images for your projects.

---

## Working with Custom Images

When you pull images from a repository or build your own, Docker saves them locally. You can manage and inspect these images using the `docker image ls` command.

**Basic Syntax:**

```sh
docker image ls [OPTIONS] [REPOSITORY[:TAG]]
```

- Lists local Docker images. By default, intermediate images are hidden.

**Useful Options:**

- `-a`, `--all` : Show all images (including intermediate layers).
- `--no-trunc` : Show full-length image IDs and other fields (no truncation).
- `-q`, `--quiet` : Show only image IDs (useful for scripting).
- `--digests` : Display image digests (unique hash for image content).
- `--filter` : Filter images by criteria (e.g., `dangling=true`, `label=key=value`, `reference=repo:tag`, `before=<image>`, `since=<image>`).

**Examples:**

Show all images, including intermediate layers:

```sh
docker image ls --all
```

Show only image IDs:

```sh
docker image ls --quiet
```

Show images with full output (no truncation):

```sh
docker image ls --no-trunc
```

Show images with their digests:

```sh
docker image ls --digests
```

Filter images by repository name:

```sh
docker image ls --filter "reference=python:*"
```

Show images created before a specific image:

```sh
docker image ls --filter "before=<image-id-or-name>"
```

Show dangling (unused) images:

```sh
docker image ls --filter "dangling=true"
```

**Tips:**

- Use multiple filters to narrow down results.
- The `before` and `since` options compare image creation times (not dates).
- The VS Code Docker extension can also display your local images visually.

By mastering these options, you can efficiently manage and inspect your custom Docker images.

---

## Tagging and Labeling Images

Tags and labels help organize Docker images for easier management and versioning.

### Tags

Tags identify distinct versions of an image. The standard format is `<repository>:<tag>`, where the tag often includes the version and sometimes the OS or key dependency (e.g., `python:3.12-bookworm`).

- If no tag is specified, Docker uses the `latest` tag by default.
- It's best practice to explicitly tag images with version numbers and only use `latest` for the most stable release.

**Tagging during build:**

```sh
docker build -t bigstarcollectibles:1.0 .
```

- Builds an image named `bigstarcollectibles` with the tag `1.0`.
- You can add multiple tags to the same image (they will share the same image ID):

```sh
docker build -t bigstarcollectibles:1.0 -t bigstarcollectibles:latest .
```

**Tagging an existing image:**

```sh
docker tag bigstarcollectibles:1.0 bigstarcollectibles:python
```

- Adds the `python` tag to the existing `bigstarcollectibles:1.0` image.

### Labels

Labels add metadata to images as key-value pairs. Common labels include `vendor`, `version`, and `description`.

**In your Dockerfile:**

```dockerfile
LABEL "vendor"="Big Star Collectibles" \
      version="1.0" \
      description="The Big Star Collectibles Website using the Python base image."
```

- You can use multiple LABEL instructions or combine them for readability.
- Use quotes and backslashes for spaces and multi-line values.

**Filtering images by label:**

```sh
docker image ls --filter "label=vendor=Big Star Collectibles"
```

- Filters images by label value.

**Tips:**

- Use clear, consistent tags for each release.
- Always specify a version tag for production images.
- Use labels to add searchable metadata for easier management.

By tagging and labeling images, you keep your Docker images organized and make it easier to manage versions and metadata, especially in shared repositories.

---

## Working with a Private Image Repository

A private image repository (or registry) lets you securely store and share Docker images with selected users.

- On Docker Hub (or another registry), create a new repository and set its visibility to private or public.

- For private repositories, invite specific users by their Docker Hub username.

- Log in to your registry from the CLI or VS Code:

```sh
docker login
```

  Enter your Docker Hub credentials when prompted.

- Tag your image with the registry/repository name before pushing:

```sh
docker tag bigstarcollectibles:1.0 sbenhoff/big-star-collectibles-repo:1.0
```

- Push the image to your private repository:

```sh
docker push sbenhoff/big-star-collectibles-repo:1.0
```

- Pull the image from your private repository:

```sh
docker pull sbenhoff/big-star-collectibles-repo:1.0
```

- You can manage and view your repositories and images using the Registries panel in the Docker extension for VS Code or directly on Docker Hub.

Using a private registry helps keep your images secure while allowing controlled sharing with collaborators.

---

### Example: Python Flask Project

```dockerfile
FROM python:3.12
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
ENV FLASK_APP=app.py
CMD ["flask", "run", "--host=0.0.0.0"]
```

```dockerfile
FROM python:3.12
WORKDIR /app
COPY pyproject.toml ./
# Optionally: COPY uv.lock ./
RUN pip install uv && uv install --no-cache
COPY . .
ENV FLASK_APP=app.py
CMD ["flask", "run", "--host=0.0.0.0"]
```

### Example: Go Web Application

```dockerfile
# Go multi-stage build example with comments
FROM golang:1.21 AS builder   
# Use the official Go image to build the app (build stage)
WORKDIR /app                          
# Set the working directory inside the builder image
COPY . .                              
# Copy the entire project into the builder image
RUN go build -o app                   
# Build the Go application and output the binary as 'app'
FROM debian:bookworm-slim             
# Use a minimal Debian image for the final container (runtime stage)
WORKDIR /app                          
# Set the working directory in the runtime image
COPY --from=builder /app/app .        
# Copy the built Go binary from the builder stage to the runtime image
CMD ["./app"]                         
# Set the default command to run the Go application
