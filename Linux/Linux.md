# Linux Basics for Cloud Engineers

## Core Concepts & System Interaction

1. **Kernel:** The core of the Linux operating system. It manages the system's resources, and acts as the bridge between your software applications and the computer's hardware.
2. **Bootloader (GRUB):** When you start a Linux system, the bootloader (commonly GRUB) is responsible for loading the Linux kernel into the system's RAM.
3. **RAM (Random Access Memory):** The kernel is loaded here to run the system.
4. **Init System (systemd):** After the kernel is loaded, the init system (commonly `systemd`) starts up. It's the first process that runs (PID 1) and is responsible for initializing the rest of the system, including starting services and mounting filesystems.
5. **User Space:** This is where user applications run, separate from the kernel space to protect the kernel.
6. **Memory Management:** The kernel handles allocating and deallocating memory for processes.
7. **Virtual Memory:** Allows the system to use more memory than is physically available by using hard drive space as temporary RAM (swap space).
8. **Virtual File System (VFS):** An abstraction layer that allows Linux to support many different file systems. It provides a common interface for user applications to interact with files, regardless of the underlying file system type.
9. **ext4:** A common default file system for many Linux distributions.
10. **Drivers:** Software that allows the kernel to communicate with hardware devices.
11. **Protection Rings:** A CPU security mechanism. The kernel runs in Ring 0 (highest privilege), while user-space applications run in Ring 3 (lowest privilege).
12. **Syscalls (System Calls):** The mechanism user-space applications use to request services from the kernel (e.g., writing a file, opening a network connection). This is how applications cross from Ring 3 to Ring 0 in a controlled manner.
13. **glibc (GNU C Library):** Provides standard C library functions, including wrappers for many system calls, making them easier for programmers to use. `unistd.h` is a header file in C that provides access to POSIX operating system API.
14. **GNU Project:** Provides many of the core utilities (coreutils) that make up a Linux operating system, like `ls`, `cp`, `mv`, etc.

### Terminal and Shell

1. **Terminal:** A graphical user interface (GUI) application that provides access to the shell.
2. **Shell:** A command-line interpreter that takes commands from the user and executes them.
3. **Bash (Bourne Again SHell):** The most common default shell in Linux distributions.
4. **`echo` command:** Used to display a line of text or the value of a variable.
    * Example: `echo "Hello Sia"`
5. **Argument:** Additional information provided to a command (e.g., `"Hello Cloud Engineer"` is an argument to `echo`).
6. **stdout (Standard Output):** The default place where commands print their output, usually the terminal screen.

### File System Navigation and Manipulation

1. **`touch` command:** Creates an empty file if it doesn't exist, or updates the access and modification timestamps of an existing file.
    * Example: `touch my_notes.txt`
2. **`man` command (manual):** Displays the manual page for a command, providing detailed information about its usage and options.
    * Example: `man ls`
3. **`ls` command (list):** Lists directory contents.
    * Example: `ls` (lists current directory)
    * Example: `ls /var/log` (lists contents of /var/log)
4. **`cat` command (concatenate):** Displays the contents of a file.
    * Example: `cat my_notes.txt`
5. **Timestamps:** Files have metadata including access, modify, and change times.
6. **`stat` command:** Displays file or file system status, including detailed timestamps.
    * Example: `stat my_notes.txt`
7. **Flags (Options):** Modify the behavior of commands. They usually start with a hyphen (`-`).
    * Example: `ls -l` (long listing format)
    * Example: `ls -h` (human-readable file sizes with `-l`)
8. **Combined Flags:** Multiple single-letter flags can often be combined.
    * Example: `ls -lh` (combines long listing and human-readable)
9. **`rm` command (remove):** Deletes files or directories.
    * Example: `rm my_notes.txt`
    * Example: `rm -rf /old_backup_directory` (removes directory recursively and forcefully - **EXTREMELY DANGEROUS IF TYPED INCORRECTLY**)
10. **Output Redirection (`>` and `>>`):**
    * `>`: Redirects the output of a command to a file, overwriting the file if it exists.
        * Example: `echo "Initial config" > server_config.txt`
    * `>>`: Redirects the output of a command to a file, appending to the file if it exists.
        * Example: `echo "Updated parameter" >> server_config.txt`
11. **Input Redirection (`<`):** Takes input for a command from a file instead of the keyboard.
    * Example (less common in daily use): `sort < unsorted_list.txt`
12. **Pipes (`|`):** Sends the standard output of one command to the standard input of another command, allowing you to chain commands together. This is extremely powerful.
    * Example: `cat error.log | sort | uniq` (Reads the log, sorts it, then removes duplicate lines)
13. **`sort` command:** Sorts lines of text.
14. **`uniq` command:** Removes duplicate adjacent lines from a sorted input.
15. **Bash Script:** A file containing a series of shell commands that can be executed together. Useful for automating tasks.
    * Starts with a **shebang**: `#!/bin/bash` at the first line to specify the interpreter.
16. **stdin (Standard Input):** The default place where commands receive input, usually the keyboard or piped from another command. The `read` command in a bash script reads from stdin.
    * Example in a script:

        ```bash
        #!/bin/bash
        echo "Enter your instance name:"
        read instance_name
        echo "You entered: $instance_name"
        ```
