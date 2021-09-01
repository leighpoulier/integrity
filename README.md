# integrity.sh

Shell script to automate creating SHA integrity hashes for use in html links.

Only tested on Linux in Bash shell.

Prints the bare hash, and the hash in the form:  
integrity=" ... [hash] ... "

For CSS and JS, also prints the full \<link\> or \<script\> tag including linkpath.  
Gives accurate link paths (for css & js) when run from the same location as the linking html file.

## Usage:
```bash
integrity.sh [-d 256|384|512] file [file]...

Options:
    -d  Specify the digest value.  Allowed values are 256, 384, 512.  Defaults to 512.
    -h  Print this help.
```
