# Bash Lesson: Pipes and Redirections

## Pipes

- Pipes (`|`) send the output of one command as input to another.
- Example: `cat lorem.txt | less` — View a long file page by page.
- Example: `cat lorem.txt | wc` — Count lines, words, and characters in a file.
- Pipes are often used with `grep`, `awk`, `sed`, and `cut` for text processing.

## Redirections

- Redirection changes where input/output of commands go.
- `>` redirects standard output (overwrites file): `ls > list.txt`
- `>>` appends standard output: `ls >> list.txt`
- `2>` redirects standard error: `ls /notreal 2>error.txt`
- `1>` (or just `>`) redirects standard output: `ls 1>output.txt`
- `<` redirects input from a file: `cat < list.txt`

## Here Document

- Use `<<` and a limit string to provide multi-line input:

```bash
cat <<END
This is a here document.
END
```

## Notes

- Piping connects commands; redirection connects commands to files.
- Standard streams: 0=input, 1=output, 2=error.

---

## Bash Built-ins vs. External Commands (Cloud Engineering Tip)

- **Built-ins** are commands built into Bash (e.g., `echo`, `cd`, `help`, `enable`). They are always available and run faster.
- Some commands (like `echo`, `printf`) exist as both built-ins and external programs. Bash uses the built-in by default.
- Use `command -V <name>` to check if a command is a built-in or external.
- Force the external version with `command <name> ...`, or the built-in with `builtin <name> ...`.
- Disable a built-in in your session with `enable -n <name>`, re-enable with `enable <name>`.
- Use `help` for built-in documentation (e.g., `help echo`).
- Built-ins are especially useful in minimal/cloud environments where some external commands may be missing.
