uhuf
====

uhuf is a CLI tool that gets files from the connected GitLab repository using API.

### Configuration

uhuf requires a config file at `/etc/uhuf.conf`, or `../etc/uhuf.conf` relative to the bin directory that holds the `uhuf` script (e.g. `/usr/local/etc/uhuf.conf`). The config file is in INI format, and needs three variables under the `uhuf` section. For example,

``` ini
[uhuf]
gitlab_url = https://gitlab.example.com
project_id = 123
private_token = _MVjujFKn87zErxzHjbVH
```

### Usage

List contents in the repository, passing an optional path:

    $ uhuf -l
    $ uhuf -l docs
    $ uhuf -l tests/api

Get raw file and print the content to stdout:

    $ uhuf docs/README.md

Download the raw file:

    $ uhuf tests/api/test_main.py

Execute the raw file and passing command-line arguments:

    $ uhuf -e scripts/run.sh
    command-line arguments: -a name

### Bash Completion

uhuf comes with a completion script `completions/uhuf.bash`. Source this script before using the `uhuf` command. The completion script also requires the config file at `/etc/uhuf.conf`, or `../etc/uhuf.conf` relative to the completion directory that holds itself.

### License
* uhuf: FreeBSD License
* [JSON.sh](https://github.com/dominictarr/JSON.sh): MIT Licence
* [bash_ini_parser](https://github.com/rudimeier/bash_ini_parser): New BSD License
