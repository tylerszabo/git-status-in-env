# git-status-in-env.sh

Sets environment variables based on [Git](https://git-scm.com/) repo status for the use in shell scripts such as prompts. Using this method allows for decoupling of interpreting the output of `git status` from logic and formatting. The behavior is defined by the tests to improve reliability and predictability.


## Usage

Source the script then call the `set_git_status_vars` function. An optional prefix can be provided as the first argument to avoid potentially collisions with other environment variables.

```bash
. git-status-in-env.sh

set_git_status_vars MY_PREFIX

echo "Git branch is $MY_PREFIX_BRANCH"
```


## Validation

Testing is implemented using [ShellSpec](https://github.com/shellspec).

Test locally with defaults:

```console
$ shellspec
```

Testing with other shell versions using Docker:

```console
$ shellspec --docker docker.io/library/bash:4.4 --shell bash
```

```console
$ shellspec --docker ghcr.io/zsh-users/zsh:4.3.11 --shell zsh
```
