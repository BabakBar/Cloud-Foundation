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
