# integrity.sh

Shell script to automate creating SHA integrity hashes for use in html links.

Only tested on Linux in Bash shell.

## Usage:
```bash
integrity.sh [-d 256|384|512] file [file]...

Options:
    -d  Specify the digest value.  Allowed values are 256, 384, 512.  Defaults to 512.
    -h  Print this help.
```
