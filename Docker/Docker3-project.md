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
```
