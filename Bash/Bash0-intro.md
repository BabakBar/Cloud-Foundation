# Bash Scripting Introduction

This document covers the basics of Bash scripting, including syntax, variables, and running scripts.

## Topics
- What is Bash?
- How to write and run a script
- Basic commands
- Variables and comments

---

### What is Bash?
Bash (Bourne Again SHell) commonly used for command-line operations and scripting.

### How to write and run a script
A Bash script is a text file containing Bash commands. Save your script with a `.sh` extension and start it with `#!/bin/bash` on the first line. Make it executable with `chmod +x script.sh` and run it with `./script.sh`.

### Basic commands
- `ls` — List files and directories
- `cd` — Change directory
- `pwd` — Print working directory
- `echo` — Print text to the terminal
- `cat` — Display file contents
- `cp` — Copy files or directories
- `mv` — Move or rename files or directories
- `rm` — Remove files or directories
- `touch` — Create an empty file
- `mkdir` — Create a new directory

Example:
```bash
ls -l
cd /home/user
pwd
echo "Hello, world!"
```

### Variables and comments
- Variables store values for use in scripts. Assign with `=`, no spaces:
  ```bash
  name="Alice"
  age=30
  echo "$name is $age years old."
  ```
- Use `$` to access variable values.
- Comments start with `#` and are ignored by Bash:
  ```bash
  # This is a comment
  echo "This line will run."
  ```
