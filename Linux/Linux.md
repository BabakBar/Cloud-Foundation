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

### Users, Groups, and Permissions

1. **`whoami` command:** Displays the current user's username.
    * Example: `whoami`
2. **UID (User ID):** A unique number assigned to each user. The system uses UIDs to identify users.
    * View your UID: `id -u`
3. **Root User (UID 0):** The superuser or administrator account. It has unrestricted access to the entire system. The username is typically `root`.
4. **`su` (substitute user) command:** Switches to another user account. If no username is specified, it defaults to `root` (requires the root password).
    * Example: `su - anotheruser` (switches to `anotheruser` with their environment)
    * Example: `su -` (switches to `root` with root's environment)
5. **`sudo` (superuser do) command:** Allows a permitted user to execute a command as the superuser or another user, as specified by the security policy (typically in `/etc/sudoers`). This is the preferred way to run commands with elevated privileges for specific tasks, rather than logging in as `root` directly.
    * Example: `sudo apt update` (runs `apt update` as root)
6. **Groups:** Users can be members of groups. Permissions can be assigned to groups, making it easier to manage access for multiple users. Each group also has a **GID (Group ID)**.
    * View your primary GID: `id -g`
    * View all groups you belong to: `groups` or `id`
7. **File Permissions (Symbolic Notation):** When you list files with `ls -l`, the first 10 characters represent the file type and permissions (e.g., `-rwxr-xr--`).
    * The first character indicates file type (`-` for regular file, `d` for directory, `l` for symbolic link).
    * The next nine characters are in three sets of three:
        * **Owner permissions** (first set of `rwx`)
        * **Group permissions** (second set of `rwx`)
        * **Other (everyone else) permissions** (third set of `rwx`)
    * `r` = read permission
    * `w` = write permission
    * `x` = execute permission (for files, allows running; for directories, allows entering)
    * A hyphen (`-`) means the permission is not granted.
8. **File Permissions (Octal Notation):** Permissions can also be represented by a 3-digit octal number (e.g., `754`). Each digit represents a set of permissions (owner, group, other):
    * Read (r) = 4
    * Write (w  2
    * Execute (x) = 1
    * Sum these numbers for the desired permissions for each category.
        * `7` = `rwx` (4+2+1)
        * `6` = `rw-` (4+2)
        * `5` = `r-x` (4+1)
        * `4` = `r--` (4)
        * `0` = `---` (0)
    * Example: `rwxr-xr--` translates to `754`.
9. **`chmod` (change mode) command:** Modifies file permissions. Can use symbolic or octal notation.
    * Symbolic Example: `chmod u+x my_script.sh` (adds execute permission for the user/owner)
    * Symbolic Example: `chmod g-w config.file` (removes write permission for the group)
    * Symbolic Example: `chmod o=r public_data.txt` (sets other permissions to read-only)
    * Symbolic Example: `chmod a+r file.txt` (adds read permission for all: user, group, and other)
    * Octal Example: `chmod 755 my_script.sh` (sets `rwxr-xr-x`)
10. **`chown` (change owner) command:** Changes the owner of a file or directory. Usually requires `sudo`.
    * Example: `sudo chown newuser:newgroup somefile.txt` (changes owner to `newuser` and group to `newgroup`)
    * Example: `sudo chown newuser somefile.txt` (changes only owner to `newuser`)
11. **`chgrp` (change group) command:** Changes the group ownership of a file or directory. Usually requires `sudo`.
    * Example: `sudo chgrp newgroup somefile.txt`
12. **Principle of Least Privilege:** A fundamental security concept. Users and processes should only have the minimum permissions necessary to perform their tasks. Avoid using `root` or overly permissive settings like `777` unless absolutely necessary and understood.

### Key File System Directories

Linux has a standard file system hierarchy. Here are some important directories for a cloud engineer:

1. **`/` (Root Directory):** The top-level directory in the Linux file system. Everything is under `/`.
2. **`/home`:** Contains the personal directories for users. For example, `/home/cloud_user`.
3. **`/boot`:** Contains files needed to boot the system, including the Linux kernel itself.
4. **`/dev`:** Contains device files that represent hardware devices (e.g., hard drives `/dev/sda`, terminals `/dev/tty`).
5. **`/etc` (et cetera):** Contains system-wide configuration files. You'll often edit files here (e.g., `/etc/ssh/sshd_config`, `/etc/nginx/nginx.conf`).
6. **`/var` (variable):** Contains files that are expected to grow in size, such as logs (`/var/log`), mail spools, and temporary files. Critical for monitoring and troubleshooting.
7. **`/bin` (binaries):** Contains essential user command binaries that are available to all users (e.g., `ls`, `cp`, `mv`).
8. **`/sbin` (system binaries):** Contains essential system binaries, typically run by the root user for system administration tasks (e.g., `fdisk`, `iptables`).
9. **`/usr` (Unix System Resources):** Contains shareable, read-only data. This includes user binaries (`/usr/bin`), libraries (`/usr/lib`), and documentation. Not to be confused with user home directories.
    * `/usr/local/bin`: Often used for programs compiled from source that are not part of the core distribution.
10. **`/tmp` (temporary):** A directory for temporary files. Files here may be deleted upon reboot.

### Environment Variables and Shell Customization

1. **`PATH` Environment Variable:** An environment variable that tells the shell which directories to search for executable files when you type a command. It's a colon-separated list of directories.
    * View your PATH: `echo $PATH`
2. **`export` command:** Makes a variable available to child processes (sub-shells). Often used to set or modify environment variables like `PATH` for the current session or within scripts.
    * Example: `export MY_API_KEY="your_secret_key"`
    * Example (adding to PATH): `export PATH="/opt/custom_app/bin:$PATH"`
3. **`.bashrc` file:** A script that Bash executes whenever an interactive non-login shell is started (e.g., opening a new terminal window). Used for user-specific aliases, functions, and environment variable settings. Located in the user's home directory (`~/.bashrc`).
4. **`.bash_profile` (or `~/.profile`, `~/.bash_login`):** A script executed when a user logs in via a login shell. Typically sources `~/.bashrc`.
5. **`PS1` Environment Variable:** Controls the appearance of your shell prompt. Customizing this can provide useful information at a glance (e.g., current directory, git branch).

### Process Management

1. **`ps` command (process status):** Displays information about currently running processes.
    * Example: `ps aux` (shows all processes from all users in BSD format)
    * Example: `ps -ef` (shows all processes in System V format)
2. **PID (Process ID):** A unique identification number for each running process.
3. **`htop` command:** An interactive process viewer and system monitor. Provides a more user-friendly and dynamic view of processes, CPU usage, memory, etc., than `ps`. Often needs to be installed (`sudo apt install htop` or `sudo yum install htop`).
4. **Daemon:** A background process that is not under the direct control of an interactive user. Daemons typically start at boot time and perform system tasks (e.g., web servers, SSH daemon).
5. **Running a command in the background (`&`):** Appending an ampersand (`&`) to a command will run it in the background, allowing you to continue using the terminal.
    * Example: `./my_long_script.sh &`
6. **`cronjob` / `crontab` command:** The `cron` daemon is used to schedule commands or scripts to run periodically at fixed times, dates, or intervals. The `crontab -e` command is used to edit the user's cron jobs.
    * Example `crontab` entry to run a backup script at 2 AM every day:
        `0 2 * * * /usr/local/bin/backup_script.sh`
7. **`kill` command:** Sends a signal to a process, usually to terminate it. Requires the PID of the process.
    * Default signal is **`SIGTERM` (15)**: Asks the process to terminate gracefully (clean up and exit).
        * Example: `kill 12345` (where 12345 is the PID)
8. **`SIGKILL` (9):** A signal that forces the kernel to terminate a process immediately, without giving it a chance to clean up. Use this as a last resort if a process is unresponsive to `SIGTERM`.
    * Example: `kill -9 12345` or `kill -SIGKILL 12345`

### Text Searching and Manipulation

1. **`grep` (Global Regular Expression Print):** Searches for patterns in text (from files or standard input) and prints the lines that match. Extremely useful for searching log files or command output.
    * Example: `grep "ERROR" application.log` (finds all lines containing "ERROR")
    * Example: `ps aux | grep nginx` (finds nginx processes)
2. **`sed` (Stream Editor):** A powerful utility for performing basic text transformations on an input stream (a file or input from a pipe). It can perform find and replace, deletion, insertion, etc.
    * Example (simple substitution): `echo "hello world" | sed 's/world/cloud/'` (outputs "hello cloud")

### File Compression and Archiving

1. **`gzip` command:** Compresses files using Lempel-Ziv coding (LZ77). Files compressed with `gzip` usually have a `.gz` extension.
    * Example: `gzip large_log_file.log` (creates `large_log_file.log.gz` and removes the original)
    * To decompress: `gunzip large_log_file.log.gz` or `gzip -d large_log_file.log.gz`
2. **`tar` (Tape Archive) command:** Creates, views, or extracts archive files (often called tarballs). `tar` itself doesn't compress but is often used with `gzip` or `bzip2`.
    * Create a gzipped archive: `tar -czvf archive_name.tar.gz /path/to/directory`
        * `c`: create
        * `z`: use gzip compression
        * `v`: verbose output
        * `f`: specify archive filename
    * Extract a gzipped archive: `tar -xzvf archive_name.tar.gz`
        * `x`: extract

### Linux Distributions (Distros) & Package Management

1. **Distro (Distribution):** A complete operating system built around the Linux kernel, including a package manager, desktop environment (for desktop versions), and pre-selected software. Examples: Ubuntu, CentOS, Debian, Fedora, Arch Linux.
2. **Package Managers:** Tools that automate the process of installing, upgrading, configuring, and removing software packages. They handle dependencies automatically.
    * **APT (Advanced Package Tool):** Used by Debian-based distros (e.g., Ubuntu, Linux Mint). Commands: `apt update`, `apt install <package>`, `apt remove <package>`.
    * **YUM (Yellowdog Updater, Modified) / DNF (Dandified YUM):** Used by Red Hat-based distros (e.g., CentOS, Fedora, RHEL). Commands: `yum install <package>`, `dnf install <package>`.
    * **Pacman:** Used by Arch Linux and its derivatives. Commands: `pacman -Syu` (update system), `pacman -S <package>`.
3. **Release Schedule:**
    * **Fixed Release:** (e.g., Ubuntu LTS, Debian Stable) New versions are released at regular intervals with long-term support options. Focus on stability.
    * **Rolling Release:** (e.g., Arch Linux, openSUSE Tumbleweed) Software is continuously updated. Provides the latest software but can sometimes be less stable.
4. **Desktop Environment:** (More relevant for desktop Linux users, but good to know) Provides the graphical user interface (GUI), including the window manager, panels, icons, etc. Examples: GNOME, KDE Plasma, XFCE. Cloud servers usually run headless (no GUI).
5. **Major Distro Families:**
    * **Slackware:** One of the oldest surviving distros, known for its simplicity and adherence to Unix principles.
    * **Debian:** Very influential; forms the base for many other distros (like Ubuntu). Known for its stability and commitment to free software.
    * **Red Hat:** Commercially focused (Red Hat Enterprise Linux - RHEL). CentOS (now CentOS Stream) and Fedora are related. Strong in the enterprise server market.
    * **Arch:** A rolling release distro known for its simplicity (in design, not necessarily ease of use for beginners), flexibility, and the Arch User Repository (AUR).


### Networking Essentials

1. **`ip addr` (or `ifconfig` - older, may not be installed by default):** Displays network interface configuration, including IP addresses, MAC addresses, and interface status.
    * Example: `ip addr show`
2. **`ping` command:** Sends ICMP ECHO_REQUEST packets to network hosts to test connectivity.
    * Example: `ping google.com` (Press `Ctrl+C` to stop)
3. **`netstat -tulnp` (or `ss -tulnp` - newer, preferred):** Shows network connections, listening ports, and the processes using them. Extremely useful for troubleshooting services.
    * `-t`: TCP ports
    * `-u`: UDP ports
    * `-l`: Listening sockets
    * `-n`: Show numerical addresses (don't resolve hostnames)
    * `-p`: Show process ID/name using the socket (often requires `sudo`)
    * Example: `sudo ss -tulnp | grep 80` (shows what's listening on port 80)
4. **`curl` (Client URL) / `wget`:** Command-line tools for transferring data with URLs. Useful for testing HTTP/S endpoints, downloading files, etc.
    * Example: `curl http://example.com` (fetches the webpage content)
    * Example: `wget https://releases.ubuntu.com/22.04/ubuntu-22.04.4-desktop-amd64.iso` (downloads the file)
5. **Firewall (e.g., `ufw`, `firewalld`, `iptables`):** Cloud environments often have security groups/network ACLs, but the host-based firewall on the Linux instance itself is also important.
    * **`ufw` (Uncomplicated Firewall):** A user-friendly frontend for `iptables`, common on Ubuntu.
        * `sudo ufw status`
        * `sudo ufw allow ssh` (or `sudo ufw allow 22/tcp`)
        * `sudo ufw enable`
    * **`firewall-cmd`:** Interface for `firewalld`, common on RHEL-based systems (CentOS, Fedora).
        * `sudo firewall-cmd --list-all`
        * `sudo firewall-cmd --permanent --add-service=http`
        * `sudo firewall-cmd --reload`
    * **`iptables`:** The underlying powerful, but complex, netfilter firewall utility.

### SSH (Secure Shell)

This is your primary tool for remotely accessing and managing cloud Linux servers.

1. **Connecting to a Server:**
    * `ssh username@hostname_or_ip`
    * Example: `ssh ec2-user@192.168.1.100`
2. **Key-Based Authentication:** Far more secure than password authentication. Involves generating an SSH key pair (public and private key). The public key is placed on the server (in `~/.ssh/authorized_keys`), and you use your private key to authenticate. Cloud providers heavily rely on this.
3. **SSH Configuration File (`~/.ssh/config`):** Allows you to define aliases and connection parameters for hosts you frequently connect to, simplifying the `ssh` command.
    * Example entry:

        ```
        Host my-prod-server
            HostName 12.34.56.78
            User ubuntu
            IdentityFile ~/.ssh/prod_key.pem
        ```

        Then you can just type `ssh my-prod-server`.
4. **`scp` (Secure Copy):** Used to securely copy files between your local machine and a remote server (or between two remote servers) over SSH.
    * Example (local to remote): `scp myfile.txt username@hostname:/remote/directory/`
    * Example (remote to local): `scp username@hostname:/remote/file.txt /local/directory/`
5. **`sftp` (Secure File Transfer Protocol):** Provides an interactive FTP-like interface for transferring files securely over SSH.

### Service Management with `systemctl`

Most modern Linux distributions use `systemd` as their init system. `systemctl` is the command to manage services (daemons).

1. **Start a service:** `sudo systemctl start <service_name>` (e.g., `sudo systemctl start nginx`)
2. **Stop a service:** `sudo systemctl stop <service_name>`
3. **Restart a service:** `sudo systemctl restart <service_name>`
4. **Check the status of a service:** `systemctl status <service_name>` (often doesn't require `sudo` just to view status)
5. **Enable a service to start on boot:** `sudo systemctl enable <service_name>`
6. **Disable a service from starting on boot:** `sudo systemctl disable <service_name>`
7. **View service logs (using journald, which `systemd` integrates with):** `sudo journalctl -u <service_name>`
    * Example: `sudo journalctl -u sshd -f` (-f follows the log)

### Finding Files

1. **`find` command:** A very powerful and flexible command for searching for files and directories based on various criteria (name, type, size, modification time, permissions, etc.).
    * Example: `find /var/log -name "*.log" -mtime -7` (finds all `.log` files in `/var/log` modified in the last 7 days)
2. **`locate` command:** Uses a pre-built database to find files by name much faster than `find`. The database needs to be updated periodically (often via `updatedb` run by cron).
    * Example: `locate myapp.conf`

### Symbolic Links (Symlinks)

1. **`ln -s` command:** Creates a symbolic link (or soft link), which is like a shortcut or pointer to another file or directory.
    * Example: `ln -s /var/log/app/very_long_path_to_current.log /home/user/current_app.log`
    * This creates `current_app.log` in the user's home directory that points to the actual log file.

### Quick Note on Text Editors

While the video mentioned Nano, Vim, and Emacs:

* **Nano:** Simple to use, good for quick edits if you're not familiar with Vim/Emacs. Most commands are shown at the bottom of the screen.
* **Vim (or Vi):** Extremely powerful and efficient once you learn its modal editing paradigm. It's installed on virtually every Linux system, making it invaluable if you have to work on a minimal server. Learning basic Vim navigation and editing (`i` for insert, `Esc` for normal mode, `:w` to write, `:q` to quit, `:wq` to write and quit) is a very good investment.

### Checking Disk Space

1. **`df -h` (disk free):** Shows disk space usage for mounted file systems in a human-readable format.
2. **`du -sh <directory>` (disk usage):** Shows the total disk space used by a specific directory in a human-readable summary.
    * Example: `du -sh /var/log/*` (shows sizes of items within /var/log)

### Applying to the Cloud

Remember, as a cloud engineer:

* You'll primarily interact with Linux instances via **SSH**.
* Understanding **networking, firewalls (both host-based and cloud provider security groups), and service management (`systemctl`)** is crucial for deploying and troubleshooting applications.
* **Log files in `/var/log`** will be your best friend for debugging.
* **Scripting with Bash** can automate many repetitive cloud tasks.
* Cloud providers offer various Linux AMIs/images (e.g., Amazon Linux, Ubuntu, RHEL on AWS/Azure/GCP). While they are standard Linux, they might have some pre-installed cloud-specific tools or configurations.
