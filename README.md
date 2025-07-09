base
====

Use `base` as an **easy way** to install the minimum essential libs/programs for open-source exploration and development. Works for Linux (Debian and Fedora based distros), Mac (via homebrew), and Windows (requires Windows Subsystem for Linux 2).

- [Setup Linux Mint and Tips](https://github.com/kenjyco/kenjyco/blob/master/setup-linux-mint-and-tips.md)
- [Setup Mac and Tips](https://github.com/kenjyco/kenjyco/blob/master/setup-mac-and-tips.md)
- [Setup Windows and Tips](https://github.com/kenjyco/kenjyco/blob/master/setup-windows-10-and-tips.md)

This document provides a complete reference to all functionality available in the base repository, including shell scripts, functions, and aliases. Commands are organized by workflow and purpose to help users discover and understand the tools available.

The shell functions and scripts are named to optimize tab-completion while using the CLI. Key patterns include:

- **Prefix-based grouping**: Type `repos-<TAB>` to see all repository management tools (scripts)
- **Function families**: Type `venv-<TAB>` to see virtual environment tools (functions)
- **Tool installation**: Type `<tool>-install<TAB>` to find installation functions
- **Example usage**: Type `example-usage--<TAB>` to discover usage pattern functions

This comprehensive toolkit provides everything needed for a complete command-line development environment, from basic file operations to advanced multi-repository management and cloud operations. The conditional availability ensures that functionality is only exposed when the necessary dependencies are met, keeping the environment clean and focused.

# Install

### If `git` is available

#### Clone the base repo

```
git clone https://github.com/kenjyco/base ~/repos/base
```

#### Move into the cloned repo

```
cd ~/repos/base
```

#### Source the install.sh file

```
source ./install.sh extras
```

> Note: If you are in an interactive **fish shell**, do not source `install.sh`,
> but invoke either `bash ./install.sh` OR `zsh ./install.sh`

The `install.sh` script behaves differently if any of the following strings are
passed in:

- **`clean`**: ensures the git/docker completion files match installed versions
  (if packages were updated)
- **`extras`**: also installs non-essential, but light-weight CLI packages like
  `vim`, `tmux`, `tree`, `ncdu`, `glances`, `nnn` and more
- **`gui`**: also installs some light-weight GUI packges for Linux (including
  xorg-server, `awesome`, `rxvt-unicode`, `feh`, `scrot`, etc) or Mac (iTerm, vlc)
- **`all`**: clean extras gui
	- this will also create the `~/tools-py` directory, with a virtual
      environment containing a number of python packages (like `asciinema`,
      `awscli`, `flake8`, `twine`, `httpie`, `grip`, and more)
    - you can run `tools-py-install-all` later if desired

### Interactive prompts during installation

#### Update completions

After the selected system packages are installed, you will be prompted if you
want to update completions for bash. Type `y` and hit enter.

```
Update completions for bash? [y/n] y
```

> This ensures that tab-completion works and will also fetch the bash or zsh
> completion file for your version of `git` (and `docker` if installed).
>
> You can call `get-completions` again if you ever install newer versions of
> `git` or `docker` in the future.

#### Select your prompt style

After that, you will be prompted to select your prompt style from five basic
options. Type the desired number and hit enter.

```
Select prompt mode
1) system-default   3) terse            5) minimal-plus
2) verbose          4) minimal
?# 5
```

> The **verbose** prompt includes the username, hostname, full path to the
> current working directory, and a newline for better visual separation. The
> **terse** prompt has the hostname and the name of the current working
> directory with no newline. The **minimal** prompt only has a single character,
> a newline, and no color. The **minimal-plus** prompt (my favorite) has a
> single character, a newline, and the name of the current working directory.
>
> All custom prompts except 'minimal' have color and will show your current git
> branch if you are in a git repo.
>
> If you are unsure, select option 2 (verbose). You can change your selection by
> running the `prompt-select-mode` command later.
>
> You can also change the prompt style for your current terminal by using any of
> the following: `prompt-system-default`, `prompt-verbose`, `prompt-terse`,
> `prompt-minimal`, or `prompt-minimal-plus`.

#### Clone and setup dotfiles

Finally, if you don't have your own custom `.vimrc` or `.tmux.conf`, you will be
prompted to clone and setup dotfiles. (Experienced users typically have their
own preferences stored in these files).

```
No local config found for vim or tmux.
Clone and setup dotfiles? [y/n] n
```

> The dotfiles repo will be cloned next to the base repo, and a number of
> symbolic links will be created in your HOME directory, pointing to files in
> the dotfiles repo (`.ctags`, `.editrc`, `.gitconfig`, `.inputrc`, `.ipython`,
> `.psqlrc`, `.tmux.conf`, `.tmux`, `.vim`, `.vimrc`, `.vimrc`, `.xinitrc`, and
> `.Xdefaults`).
>
> You can use `dotfiles-install` later on if desired. See:
> <https://github.com/kenjyco/dotfiles>

# About

When you source the `install.sh` script, your package manager will install
or update some packages, three symbolic links will be created in your
`$HOME` directory, and `~/commands.sh` will be "auto-sourced" at the end
(i.e. if using bash/zsh, the "shell functions" defined in `~/commands.sh` will
be "loaded" into your shell whenever you start a session, allowing you to call
any of those funcitons by name while using the terminal).

- `~/bin-base` -> /path/to/base/bin
    - directory containing some executable shell scripts
- `~/commands.fish` -> /path/to/base/commands.fish
    - file that can/should be sourced if using an interactive fish session
    - *only a small subset of what is available in commands.sh*
- `~/commands.sh` -> /path/to/base/commands.sh
    - file that can/should be sourced if using an interactive bash/zsh session
    - contains definitions of **many useful shell functions and aliases**

When you source `~/commands.sh` or `~/commands.fish` (directly or indirectly):

- GNU versions of `find`, `grep`, `sort`, and `xargs` will be used if they are
  installed on a Mac (over the default BSD versions)
- shell completions will be enabled for your installed versions of `git` and
  `docker`
- **vi keybindings will be used for navigating/editing the command line**
    - *i.e. hit <Esc> to enter "command mode" (to issue vi commands) and
      `i`/`I`/`a`/`A` to get back to "insert mode"*
    - effective to reinforce/practice vi motions for early learners
- any shell functions defined inside can be called
    - *Note: most functions/aliases are conditionally defined, meaning that
      no assumptions are made about what programs are available to your
      system...*
        - if a shell func or alias makes use of a particular program and you
          don't have that program installed on your system, the func or alias
          will not be defined
        - if a shell func or alias requires using `sudo` (and you're not in
          the sudo/admin group, or the root user), the func or alias will not
          be defined
- the `~/bin-base` directory will be added to your `$PATH` environment variable,
  allowing you to invoke any of the scripts in there

# Update

```
base-update
```

> That command will `cd` to wherever you initially cloned this base repository,
> pull in the latest changes via `git`, and re-source the install.sh file.

# Reference

- **Scripts**: Executable files in `bin/` directory (marked with [script])
- **Functions**: Shell functions defined in `commands.sh` (marked with [function])
- **Aliases**: Short command aliases (marked with [alias])

---

## Navigation and Directory Management

Essential tools for moving around the filesystem and managing directories.

### Basic Navigation
- [alias] **`..`** - Change to parent directory
- [alias] **`...`** - Change to grandparent directory
- [alias] **`....`** - Change to great-grandparent directory
- [function] **`cdd <directory>`** - Create directory and change into it
- [function] **`here`** - Get basename of current directory

### Repository Navigation
*Functions in this group are only available if `~/.base_path` file exists*

- [function] **`base`** - Change to base repository directory
- [function] **`base-update`** - Use git to update the base repository
- [function] **`dotfiles-install`** - Clone the dotfiles repository next to base

*Functions in this group are only available if `~/.dotfiles_path` file exists*

- [function] **`dotfiles`** - Change to dotfiles repository directory
- [function] **`dotfiles-update`** - Use git to update the dotfiles repository

*Functions in this group are only available if the `PACKAGE_REPOS_DIR` variable is set or `~/repos/personal/packages` directory exists*

- [function] **`package-repos`** - Change to the packages directory containing a variety of repositories
- [function] **`kenjyco-usage-across-packages`** - Use `grep-object-info` to show usage patterns across kenjyco packages

---

## Repository Management

Comprehensive tools for managing multiple Git repositories across your development environment. The repos-* family provides a unified interface for analyzing, maintaining, and operating on multiple Git repositories simultaneously. All scripts accept an optional path parameter and use intelligent discovery to find repositories. This makes it very convenient if you organize your repositories into sub-directories.

### Core Repository Discovery
- [script] **`repos-list [path]`** - Foundation script that discovers all Git repositories
- [script] **`repos-list-display [path]`** - Display repository paths with home/current directory substitution

### Repository Status and Information
- [script] **`repos-status [path]`** - Comprehensive status overview showing branches, commits, stashes, and changes
- [script] **`repos-status--changes-only [path]`** - Show only repositories with uncommitted changes
- [script] **`repos-dirs [path]`** - Analyze repository directory distribution and organization
- [script] **`repos-last-commit-dates [path]`** - Show last commit timestamp for each repository

### Branch Management and Analysis
- [script] **`repos-branches [path] [pattern]`** - Show branches with timestamps and pattern matching
  - `path`: Directory to search
  - `pattern`: Branch name pattern to match
- [script] **`repos-branches-all [path] [pattern]`** - Extended branch view with complete history
- [script] **`repos-branches-short [path]`** - Concise branch listing showing current branch per repo
- [script] **`repos-branches--non-master-develop [path]`** - Show only non-standard branches

### Commit History and Analysis
- [script] **`repos-commits [path] [git-log-args...]`** - Basic commit log across repositories
  - `path`: Directory to search
  - `git-log-args`: Any arguments passed to git log
- [script] **`repos-commits2 [path] [git-log-args...]`** - Detailed commit view with file changes
- [script] **`repos-commits3 [path] [git-log-args...]`** - Full diff view with patches
- [script] **`repos-commits-not-on-master [path] [branch]`** - Show commits unique to branches vs master
  - `branch`: Comparison branch (defaults to master)
- [script] **`repos-commits-not-on-develop [path] [branch]`** - Show commits unique to branches vs develop
- [script] **`repos-commits-since-last-tag [path]`** - Show commits since most recent tag
- [script] **`repos-commits-since-last-tag--full [path]`** - Complete commit history since last tag

### File Discovery and Analysis
- [script] **`repos-files [path] [pattern]`** - Search for files across repositories with modification timestamps
  - `pattern`: File name pattern to match (`grep -E` style accepted)
- [script] **`repos-files-by-first-commit [path] [pattern]`** - Files sorted by creation date
- [script] **`repos-files-quick [path]`** - Fast file enumeration without timestamps
- [script] **`repos-files-counts [path]`** - File count per repository
- [script] **`repos-files-counts-sorted [path]`** - File counts sorted by quantity
- [script] **`repos-untracked-files [path]`** - Show untracked files across repositories
- [script] **`repos-ignored-files [path]`** - Show files matched by .gitignore

### Diff and Comparison Operations
- [script] **`repos-diffs [path] [git-diff-args...]`** - Show working directory changes
  - `git-diff-args`: Arguments passed to git diff
- [script] **`repos-diffs-since-last-tag [path]`** - Show all changes since last tag
- [script] **`repos-diffs-with-branch [path] [branch] [git-diff-args...]`** - Compare current branch with another
  - `branch`: Target branch for comparison (defaults to origin/develop)

### Tag Management
- [script] **`repos-tags [path]`** - Show tag history with dates
- [script] **`repos-tags-messages [path]`** - Show tag messages and annotations
- [script] **`repos-last-tag [path]`** - Show most recent tag per repository
- [script] **`repos-last-tag-message [path]`** - Show most recent tag message

### Repository Maintenance
- [script] **`repos-update [path]`** - Intelligent repository updating with stash/pull/pop logic
- [script] **`repos-update--skip-swps [path]`** - Update repositories, skipping those with vim swap files
- [script] **`repos-fetch [path]`** - Fetch updates, showing only repositories with changes
- [script] **`repos-delete-local-branches [path]`** - Interactive branch cleanup with diff preview

### Repository Metadata
- [script] **`repos-name-email [path]`** - Show git user configuration for each repository
- [script] **`repos-remotes [path]`** - Show remote repository URLs
- [script] **`repos-show-stashes [path]`** - Show all stashed changes with diffs

### Bulk Operations
- [script] **`repos-do [path] <command...>`** - Execute arbitrary commands in each repository
  - `command`: Shell command to execute in each repo
- [script] **`repos-do-output [path] <command...>`** - Execute commands, show only repositories with output

---

## Python Virtual Environment Management

Complete toolkit for Python development environment management with cross-platform support.

### Environment Setup and Management
- [script] **`venv-setup [env_name] [clean]`** - Complete virtual environment setup with dependency installation (if `requirements.txt` file exists), pyenv integration (if `.python-version` file exists), and automatic
  editable installs (if `setup.py` file exists)
  - `env_name`: Name of virtual environment (defaults to 'venv')
  - `clean`: Remove existing environment first
- [script] **`venv-setup-lite [env_name] [clean]`** - Minimal virtual environment setup (not adding `ipython`, `pytest`, or `pdbpp`)
- [script] **`venv-clean [env_name]`** - Clean virtual environment and build artifacts
- [function] **`venv-site-packages <env_name>`** - Navigate to site-packages directory
- [function] **`venv-quick`** - Quick venv creation with pip/wheel upgrade

### Development and Testing
- [script] **`venv-ipython [env_name] [ipython-args...]`** - Launch IPython in virtual environment
  - `ipython-args`: Arguments passed to IPython
- [script] **`venv-pytest [env_name] [pytest-args...]`** - Run pytest with comprehensive defaults
  - `pytest-args`: Arguments passed to pytest
- [script] **`venv-pytest-no-warnings [env_name] [pytest-args...]`** - Run pytest without warning output

### Environment Analysis
- [script] **`venv-freeze [env_name]`** - Show installed packages
- [script] **`venv-deptree [env_name] [pipdeptree-args...]`** - Show dependency tree visualization
  - `pipdeptree-args`: Arguments passed to pipdeptree
- [script] **`venv-pip-version [env_name]`** - Get pip version in environment

---

## File Search and Discovery

Advanced file finding tools with intelligent filtering and extensive customization options.

### Advanced File Search
- [script] **`findit [dir] [options...]`** - Comprehensive file finder with extensive filtering options
  - `dir`: Directory to search (defaults to current)
  - `--depth <number>`: Maximum search depth
  - `--type <f|d|l|s|b>`: File type (file, directory, link, socket, block)
  - `--pattern <patterns>`: Comma-separated filename patterns
  - `--ipattern <patterns>`: Comma-separated filename patterns (case insensitive)
  - `--complex <string>`: Raw options passed directly to `find`
  - `--exclude_dirs <patterns>`: Comma-separated directories to exclude
  - `--iexclude_dirs <patterns>`: Comma-separated directories to exclude (case insensitive)
  - `--exclude <patterns>`: Comma-separated filename patterns to exclude
  - `--iexclude <patterns>`: Comma-separated filename patterns to exclude (case insensitive)
  - `--exts <extensions>`: Comma-separated file extensions to include
  - `--iexts <extensions>`: Comma-separated file extensions to include (case insensitive)
  - `--sizes <sizes>`: Size filters (+/-2G, +1M, etc.)
  - `--empty`: Empty files only
  - `--not_empty`: Non-empty files only
  - `--months <number>`: Files modified within months
  - `--weeks <number>`: Files modified within weeks
  - `--days <number>`: Files modified within days
  - `--hours <number>`: Files modified within hours
  - `--minutes <number>`: Files modified within minutes
  - `--pipe <command>`: Pipe results to command
  - `--pipesort <command>`: Pipe sorted results to command
  - `--zero`: Print matching filenames delimited by null char (-print0) to pipe to `xargs -0 -I {}`
  - `--stamp`: Prepend timestamps to output
  - `--help`: Show help message with options and examples

### Specialized File Finding
- [function] **`findit-default-excludes`** - Find with standard development exclusions
- [function] **`findit-py`** - Find Python files
- [function] **`findit-py-no-tests`** - Find Python files excluding test directories
- [function] **`findit-test-dirs`** - Find test directories
- [function] **`findit-node-modules`** - Find node_modules directories
- [function] **`findit-js-backend`** - Find backend JavaScript files
- [function] **`findit-tf`** - Find Terraform files
- [function] **`findit-docs`** - Find documentation files
- [function] **`findit-pics`** - Find image files
- [function] **`findit-audio`** - Find audio files
- [function] **`findit-vids`** - Find video files
- [function] **`findit-logs`** - Find log files
- [function] **`findit-json-slow`** - Find JSON files (thorough method)

### Vim Swap File Management
- [function] **`swps`** - Find vim swap files with timestamps
- [function] **`swps-no-stamp`** - Find vim swap files without timestamps
- [function] **`swps-delete`** - Delete vim swap files

### File Cleanup Operations
- [function] **`delete-node-modules`** - Delete all node_modules directories
- [script] **`clean-py`** - Remove Python build artifacts (.eggs, __pycache__, build, dist)
- [function] **`show-mac-garbage`** - Show macOS system files (.DS_Store, etc.)
- [function] **`delete-mac-garbage`** - Delete macOS system files

---

## Code Search and Analysis

Powerful tools for searching and analyzing code across projects with intelligent filtering.

### Core Search Functions
- [function] **`grepit <pattern>`** - Recursive grep with smart exclusions and color output
  - `pattern`: Search pattern (supports regex)
- [function] **`grepit-count <pattern>`** - Count grep matches by file
- [function] **`grepit-count-dirs <pattern>`** - Count grep matches by directory
- [function] **`grepit-non-matching-files <pattern>`** - Find files without matches
- [function] **`grepit-cut <pattern>`** - Truncated grep output for overview
- [function] **`grepit-exact <pattern>`** - Exact word matching

### Language-Specific Search
- [function] **`grepit-py <pattern>`** - Search Python files only
- [function] **`grepit-py-no-tests <pattern>`** - Search Python files excluding test directories
- [function] **`grepit-py-imports`** - Find Python import statements
- [function] **`grepit-py-imports-no-tests`** - Find Python imports excluding tests
- [function] **`grepit-md <pattern>`** - Search markdown files

### Filtered Search Options
- [function] **`grepit-no-docs <pattern>`** - Search excluding documentation files
- [function] **`grepit-no-docs-no-tests <pattern>`** - Search excluding docs and tests
- [function] **`grepit-md-include-venv-and-node_modules <pattern>`** - Search markdown including normally excluded directories

### Special Search Functions
- [function] **`grepit-tabs`** - Find tab characters in files
- [function] **`grepit-todo`** - Find TODO comments
- [function] **`grep-object-info <object>`** - Analyze object method/attribute usage patterns
  - `object`: Python object to analyze
- [function] **`grep-object-info-no-tests <object>`** - Analyze object usage excluding tests

### Log File Analysis
- [function] **`grep-logs <pattern>`** - Search in log files
- [function] **`logs-empty`** - Find empty log files
- [function] **`logs-empty-delete`** - Delete empty log files
- [function] **`logs-wcl`** - Count lines in log files
- [function] **`logs-info`** - Find INFO entries in logs
- [function] **`logs-error`** - Find ERROR entries in logs
- [function] **`logs-debug`** - Find DEBUG entries in logs

---

## Tool Installation and Environment Management

Streamlined installation and management of development tools with automatic environment setup. Most installation functions create isolated environments and automatically make tools available after installation by re-sourcing commands.sh.

### Core Installation Tools
- [function] **`get-completions`** - Download bash/zsh completions for git and docker

### Development Environment Managers
*These functions are only available if the respective tools don't already exist*

- [function] **`pyenv-install`** - Install Python Version Manager
- [function] **`nvm-install`** - Install Node Version Manager
- [function] **`gvm-install`** - Install Go Version Manager
- [function] **`rust-install`** - Install/update Rust via rustup

### Python Development Tools
- [function] **`tools-py-install-all`** - Install comprehensive Python tool suite in isolated environment (`~/tools-py` directory)
    - includes: asciinema, awscli, flake8, twine, httpie, jupyter, grip, rdbtools, sql-helper

*Tools are installed in `~/tools-py/venv` and wrapper functions are created automatically*

- [function] **`asciinema-install`** - Install terminal session recorder
- [function] **`flake8-install`** - Install Python linting tool
- [function] **`jupyter-install`** - Install Jupyter notebook environment
- [function] **`twine-install`** - Install Python package publishing tool
- [function] **`grip-install`** - Install markdown preview server
- [function] **`aws-install`** - Install AWS CLI

### HTTP and Network Tools
*Tools are installed in `~/tools-py/venv` and wrapper functions are created automatically*

- [function] **`http-install`** - Install HTTPie HTTP client
- [function] **`sql-install`** - Install SQL helper tools
- [function] **`rdb-install`** - Install Redis RDB analysis tools

### Infrastructure Tools
- [function] **`kubectl-install`** - Install Kubernetes CLI
- [function] **`kind-install`** - Install Kubernetes in Docker
- [function] **`terraform-install`** - Install multiple Terraform versions
- [function] **`circleci-install`** - Install CircleCI CLI
- [function] **`docker-install`** - Install Docker (Linux only, requires sudo)

### Kenjyco Development Suite
- [function] **`kenjyco-install-dev-setup`** - Install kenjyco development libraries
- [function] **`kenjyco-dev-setup`** - Run kenjyco development environment setup
- [function] **`kenjyco-full-update`** - Update kenjyco libraries with full dependencies

---

## Version Management

Tools for managing multiple versions of programming languages and their dependencies. Functions in this section are only available if the respective version managers are installed.

### Python Version Management
*Available only if pyenv is installed*

- [function] **`pyenv-list-installable`** - List available Python versions for installation
- [function] **`pyenv-list-grep <pattern>`** - Search available Python versions
  - `pattern`: Version pattern to match
- [function] **`pyenv-list-versions-installed`** - List currently installed Python versions
- [function] **`pyenv-list-python-version-files`** - Find .python-version files in projects
- [function] **`pyenv-install-latest-python`** - Install latest stable Python version
- [function] **`pyenv-pip-versions`** - Show pip versions across pyenv installations
- [function] **`pyenv-package-versions <package>`** - Show package versions across pyenv installations
  - `package`: Python package name
- [function] **`pyenv-select-python-versions-to-install`** - Interactive Python version selection
- [function] **`tools-py-create-venv-from-pyenv-version`** - Create tools-py venv from specific pyenv version

### Go Version Management
*Available only if gvm is installed*

- [function] **`go-version`** - Get current Go version
- [function] **`go-minor-version`** - Get Go minor version
- [function] **`gvm-list-installable`** - List available Go versions
- [function] **`gvm-list-installable-all`** - List all available Go versions
- [function] **`gvm-list-versions-installed`** - List installed Go versions
- [function] **`gvm-install-latest-go`** - Install latest Go version

---

## File Operations and Display

Enhanced file listing and content display tools with timestamps and formatting options.

### Enhanced File Listing
- [function] **`f`** - List files with modification timestamps
- [function] **`fa`** - List files including hidden ones
- [function] **`f5`** - List last 5 modified files
- [function] **`f10`** - List last 10 modified files
- [function] **`d`** - List directories with timestamps
- [function] **`da`** - List directories including hidden ones
- [function] **`d5`** - List last 5 modified directories
- [function] **`d10`** - List last 10 modified directories
- [function] **`l`** - List symbolic links
- [function] **`la`** - List symbolic links including hidden ones
- [function] **`l5`** - List last 5 symbolic links
- [function] **`l10`** - List last 10 symbolic links

### File Content Display
- [function] **`cat-with-titles`** - Display files with delimited section headers
- [function] **`cat-with-titles-pound`** - Display files with pound sign headers
- [function] **`cat-with-titles-html`** - Display files with HTML comment headers

### Directory Navigation Trees
*Available only if tree command exists*

- [function] **`t`** - Tree view with file type indicators
- [function] **`td`** - Tree view showing directories only

### Path Utilities
- [script] **`clean-path-outputs`** - Clean up file paths in piped output
  (replaces $PWD with '.', $HOME with '~'), used mostly with `repos-*` scripts

---

## System Information and Monitoring

Comprehensive tools for monitoring system resources, processes, and hardware status.

### System Overview
- [function] **`system-info`** - Comprehensive system information display
- [function] **`dfh`** - Disk usage with intelligent filtering
- [function] **`duh`** - Directory sizes sorted by size
- [function] **`now`** - Current timestamp
- [function] **`utcnow`** - Current UTC timestamp
- [function] **`now-banner`** - Current time as large banner text (if banner command exists)

### Process Management
- [function] **`p`** - Show user processes with filtering
- [function] **`pa`** - Show all processes
- [function] **`psome`** - Show filtered processes excluding system components
- [function] **`papps`** - Show macOS applications (requires perl with PCRE support)
- [function] **`pst`** - Process tree display (if pstree exists)

### Hardware and System Information
- [function] **`etc-group`** - Display system groups
- [function] **`etc-passwd`** - Display system users

*Functions in this group require specific system tools (linux only)*

- [function] **`battery`** - Show battery status and remaining time (requires acpi)
- [function] **`hardware`** - Show detailed hardware information (requires lshw and sudo)

### Storage and Partitions
*Available only if lsblk command exists (linux only)*

- [function] **`partitions`** - Show disk partitions and mount points
- [function] **`partitions-uuid`** - Show partitions with UUIDs
- [function] **`partitions-by-size`** - Show partitions sorted by size
- [function] **`partitions-iso9960-only`** - Show ISO9660 partitions only
- [function] **`partitions-snap-only`** - Show snap partitions only
- [function] **`lsblk-all-fields-json`** - Show all partition fields as JSON

### Environment and Configuration
- [function] **`env-var-names`** - List environment variable names
- [function] **`paths`** - Display PATH components on separate lines
- [function] **`crontab-active`** - Show active cron jobs

### Monitoring and Watching
*Watch functions require watch command*

- [function] **`watchit <command>`** - Watch command output every 10 seconds
  - `command`: Command to execute repeatedly
- [function] **`watch-battery`** - Continuously monitor battery status
- [function] **`watch-partitions`** - Continuously monitor partition status

---

## Network and Remote Access

Tools for network configuration, WiFi management, and remote access setup.

### Network Information
- [script] **`ip-local`** - Get local IP addresses (excludes loopback and private ranges)
- [script] **`ip-local-all`** - Get all local IP addresses including private ranges
- [script] **`ip-public`** - Get public IP address via external services
- [function] **`dig-short <hostname>`** - Quick DNS lookup (requires dig)
  - `hostname`: Domain name to resolve

### WiFi Management
*Available only if nmcli (NetworkManager) exists (linux only)*

- [function] **`nmcli-list-networks`** - List available WiFi networks
- [function] **`nmcli-status`** - Show network connection status
- [function] **`nmcli-connect-to <ssid>`** - Connect to WiFi network
  - `ssid`: WiFi network name
- [function] **`nmcli-reconnect-to <ssid>`** - Reconnect to known WiFi network

### Network Scanning and Analysis
*These functions require sudo privileges*

- [function] **`lsof-ports-ipv4`** - Show IPv4 port usage
- [function] **`nmap-local-machines10`** - Scan 10.x.x.x network for hosts
- [function] **`nmap-local-machines192`** - Scan 192.168.x.x networks for hosts

### SSH Management
- [function] **`sshlazy`** - Lazy SSH key loading and management
- [function] **`sshlazy-select`** - Interactive SSH key selection
- [function] **`ssh-fix-permissions`** - Fix SSH directory and key permissions

---

## Git Operations

Enhanced Git workflow tools for advanced repository management and automation. Git aliases are only available if git command exists.

### Git Aliases
- [alias] **`glog`** - Formatted git log with colors and concise output
- [alias] **`glog2`** - Git log with file change status
- [alias] **`glog3`** - Git log with full patches and statistics

### Git Workflow Enhancements
- [function] **`git-email-address`** - Get git email configuration for current repository
- [function] **`git-merge-in <branch>`** - Merge branch with automatic stash handling
  - `branch`: Branch to merge into current branch
- [function] **`git-stash-parts`** - Interactive partial stashing
- [function] **`git-stash-all-with-comment <comment>`** - Stash all changes with descriptive comment
  - `comment`: Description for the stash
- [function] **`git-update-submodules`** - Update all git submodules recursively

### Quick Commit Helpers
- [function] **`lazy-add-commit <file>`** - Add specific file and commit with generated message
  - `file`: File to add and commit
- [function] **`lazy-commit-from-added-files`** - Commit only files already added to staging

---

## Docker Operations

Complete Docker workflow management for containers, images, and system maintenance. All functions are only available if docker command exists.

### Docker Image Management
- [function] **`docker-login`** - Login to Docker registry with token handling
- [function] **`docker-get-auth-token`** - Retrieve Docker authentication token
- [function] **`docker-delete-all-images`** - Delete all Docker images
- [function] **`docker-delete-untagged-images`** - Delete untagged images only
- [function] **`docker-delete-unused-images`** - Delete unused images
- [function] **`docker-show-all-images`** - Display all Docker images
- [function] **`docker-show-untagged-images`** - Display untagged images

### Docker Container Management
- [function] **`docker-stop-all-containers`** - Stop all running containers
- [function] **`docker-delete-all-containers`** - Delete all containers
- [function] **`docker-show-all-containers`** - Display all containers
- [function] **`docker-shell <container>`** - Open interactive shell in container
  - `container`: Container name or ID

### Docker System Operations
- [function] **`docker-prune`** - Prune Docker system (remove unused data)
- [function] **`docker-ls`** - List all Docker resources
- [function] **`docker-destroy-all`** - Destroy all Docker images and containers
- [function] **`docker-top`** - Show Docker resource usage
- [function] **`docker-show-all-images-and-containers`** - Display images then containers
- [function] **`docker-show-all-containers-and-images`** - Display containers then images

---

## AWS Cloud Operations

Tools for AWS cloud infrastructure management and multi-region operations. All functions are only available if aws command exists.

### AWS Elastic Beanstalk
- [function] **`beanstalk-versions-by-app`** - Show Beanstalk application versions
- [function] **`beanstalk-total-versions`** - Count total Beanstalk versions across apps

### AWS Region Management
- [function] **`aws-region-names`** - List all AWS region names
- [function] **`aws-region-cycle <command>`** - Execute command across all AWS regions
  - `command`: AWS CLI command to run in each region

---

## Package Management

System package management tools for different Linux distributions and package managers.

### APT Package Management (Debian/Ubuntu)
*Available only if apt-cache command exists*

- [function] **`acs <package>`** - Search packages starting with name
  - `package`: Package name to search
- [function] **`acs2 <package>`** - Search packages containing name
- [function] **`upgradable`** - List packages available for upgrade
- [function] **`apt-sources`** - Show APT repository sources
- [function] **`manually-installed`** - Show manually installed packages

### YUM Package Management (RHEL/CentOS)
*Available only if yum command exists*

- [function] **`yum-search <package>`** - Search YUM repositories for package
  - `package`: Package name to search

---

## Media and Content Management

Tools for handling multimedia files, weather information, and news content. Many functions require external services or specific tools.

### Image and Media Viewing
*Functions are conditionally available based on installed tools*

- [alias] **`feh`** - Enhanced image viewer with scaling (if feh exists)
- [alias] **`fehf`** - Fullscreen image viewer with maximum zoom (if feh exists)
- [function] **`pics-view`** - View images using feh
- [function] **`audio-play`** - Play audio files using mocp
- [function] **`vids-play`** - Play video files using VLC
- [alias] **`vlc`** - VLC media player (macOS, if VLC.app exists)
- [function] **`vlcf`** - VLC in fullscreen mode

### Media Conversion
*Available only if required conversion tools exist*

- [function] **`to_mp3 <file>`** - Convert audio/video file to MP3 (requires ffmpeg)
  - `file`: Source file to convert
- [function] **`to_rst <file>`** - Convert markdown file to ReStructuredText (requires pandoc)
  - `file`: Markdown file to convert

### Weather and News
*Requires curl for external service access*

- [function] **`weather-now [location]`** - Get current weather information
  - `location`: City or location (optional)
- [function] **`weather-forecast [location]`** - Get weather forecast
- [function] **`news-help`** - Show news service help
- [function] **`news-search <query>`** - Search news articles
  - `query`: Search terms
- [function] **`news-cat-business`** - Get business news
- [function] **`news-cat-entertainment`** - Get entertainment news
- [function] **`news-cat-general`** - Get general news
- [function] **`news-cat-health`** - Get health news
- [function] **`news-cat-science`** - Get science news
- [function] **`news-cat-sports`** - Get sports news

---

## Document Processing

Tools for working with documentation files and markup formats. Most functions require pandoc or other document processing tools.

### Markdown Processing
*Available only if pandoc exists*

- [function] **`mdcat`** - Convert markdown to plain text
- [function] **`mdless`** - Page markdown as plain text
- [function] **`mdview`** - View markdown in lynx browser (requires lynx)
- [function] **`grip-many`** - Serve multiple markdown files with grip server

### JSON Processing
*Available only if jq exists*

- [function] **`jq-pretty-less`** - Pretty print JSON with paging

---

## Terminal and Desktop Management

Advanced terminal management, recording, and desktop environment control. Many functions require specific GUI tools or X11 environment.

### Terminal Window Management
*Available only if urxvt exists*

- [function] **`windowsize <size> [title]`** - Open new terminal with specific size
  - `size`: Terminal size (e.g., "80x24")
  - `title`: Window title (optional)
- [function] **`big-window`** - Open large terminal window
- [function] **`newwin [title] [geometry]`** - Open new terminal window
  - `title`: Window title (optional)
  - `geometry`: Window geometry (optional)
- [function] **`new-asciicast-win`** - Open optimized window for asciinema recording

### Session Recording
*Requires `asciinema`*
- [function] **`asciicast [title]`** - Record terminal session with tmux
  - `title`: Recording title (optional)
- [function] **`asciicast-no-tmux [title]`** - Record terminal session without tmux

*Requires `recordmydesktop` (linux only)*
- [function] **`screencast [title]`** - Record desktop screen
  - `title`: Recording title (optional)
- [function] **`screencast-not-on-the-fly [title]`** - Record desktop without real-time encoding

*Requires `scrot` (linux only)*
- [function] **`screenshot`** - Take screenshot
- [function] **`scrot-loop`** - Interactive screenshot loop

### Tmux Session Management
- [function] **`Tmux [session]`** - Attach to or create tmux session
  - `session`: Session name (optional)
- [function] **`Tmux-join <session>`** - Join existing tmux session
  - `session`: Session name to join

### Display and Desktop Control
*Available only in X11 environments with appropriate tools (linux only)*

- [function] **`wallpaper-select-mode`** - Select wallpaper display mode (requires wallpaper scripts)
- [function] **`wallpaper-select`** - Select specific wallpaper
- [function] **`xrandr-connected-displays`** - Show connected displays (requires xrandr)
- [function] **`xrandr-fix-monitors [position]`** - Configure multiple monitor setup
  - `position`: Monitor position (e.g., "left", "right")

### Screen Lock and Screensaver
*Available only if xscreensaver exists*

- [function] **`screensaver-stop`** - Stop screensaver
- [function] **`screensaver-start`** - Start screensaver
- [function] **`screensaver-select`** - Select screensaver configuration
- [function] **`lockscreen`** - Lock screen

---

## Note-Taking and Documentation

Tools for creating and managing notes and documentation files.

### Note Creation
- [script] **`note [filename|directory]`** - Create/edit timestamped markdown files
  - `filename`: Specific filename (optional)
  - `directory`: Directory for new note (optional)
- [script] **`note2 [filename|directory]`** - Enhanced note-taking with header insertion

---

## Development and Testing Tools

Specialized tools for development workflows, testing, and code analysis.

### Function Discovery and Help
- [function] **`funcs-list`** - List most available shell functions
- [function] **`funcs-list-all`** - List all shell functions including hidden ones
- [function] **`funcs-list-hidden`** - List hidden shell functions only
- [function] **`funcs-that-do`** - List functions containing "do" in their name
- [function] **`funcs-that-install`** - List functions containing "install" in their name

### CircleCI Integration
*Available only if circleci command exists*

- [function] **`circleci-local-test <job>`** - Test CircleCI job locally
  - `job`: CircleCI job name to test

### Redis Analysis
- [function] **`redis-usage <dump_path>`** - Analyze Redis memory usage from dump file
  - `dump_path`: Path to Redis dump file

---

## History and Documentation

Tools for searching command history and accessing documentation.

### Command History Search
- [function] **`grep-history <pattern>`** - Search shell command history
  - `pattern`: Search pattern
- [function] **`grep-history-exact <pattern>`** - Exact word search in command history
- [function] **`grep-history-comments`** - Find commented entries in command history

### Help and Manual Systems
- [function] **`helpme <command>`** - Show complete function and script definitions
  - `command`: Command to get help for
- [function] **`commands-functions-aliases`** - Export all commands to file and view with `less`
- [function] **`man-f <command>`** - Show short manual description
  - `command`: Command to describe
- [function] **`man-list`** - List all available manual pages
- [function] **`man-grep <command> <phrase> [lines]`** - Search manual pages
  - `command`: Manual page to search
  - `phrase`: Text to find
  - `lines`: Context lines (optional)

---

## Vim and Editor Integration

Tools that enhance vim workflow and provide specialized editing capabilities.

### Vim Utilities
- [function] **`vimdiff-dirs <dir1> <dir2>`** - Directory comparison in vim (requires vim-dirdiff plugin)
  - `dir1`: First directory to compare
  - `dir2`: Second directory to compare
- [function] **`vim-spell`** - Open vim with spell checking enabled

---

## System Administration

Advanced system administration tools requiring elevated privileges. Most functions in this section require sudo access and are only available to users in admin groups.

### User Management
*Available only to users with sudo privileges*

- [function] **`newuser <username> [sudo|docker]`** - Create new user with optional privileges
  - `username`: New user account name
  - `sudo|docker`: Additional group membership (optional)
- [function] **`newusergit <username>`** - Create specialized git user account
  - `username`: Git user account name
- [function] **`purgeuser <username>`** - Delete user and home directory
  - `username`: User account to remove
- [function] **`sudo-users`** - Show members of sudo group
- [function] **`etc-shadow`** - Show system shadow file entries

### System Configuration
*Requires sudo privileges*

- [function] **`set-hostname <hostname>`** - Set system hostname
  - `hostname`: New system hostname
- [function] **`ntp-sync-now`** - Synchronize system time with NTP servers

### Package Management
*Available only on systems with APT and requires sudo*

- [function] **`make-security-only-list`** - Create security-only APT sources list
- [function] **`do-security-upgrades`** - Apply security updates only
- [function] **`uninstall-hard <package>`** - Completely purge package and dependencies
  - `package`: Package to remove

### System Control
*Available only to users with sudo privileges*

- [alias] **`shutdown`** - Immediate system shutdown
- [alias] **`reboot`** - System reboot
- [alias] **`hibernate`** - System hibernation

---

## Backup and Project Creation

Tools for backup management and repository creation.

### Backup Operations
- [script] **`backup.py [source] [destination]`** - Intelligent rsync wrapper with exclusions
  - `source`: Source directory to backup
  - `destination`: Backup destination

### Repository Creation
- [script] **`makerepo <repo_name>`** - Create and initialize remote Git repository
  - `repo_name`: Name of new repository

---

## Security and Certificates

Tools for security analysis and certificate management.

### Certificate Management
- [script] **`check-cert-and-key <cert_file> <key_file>`** - Verify SSL certificate and key matching
  - `cert_file`: SSL certificate file
  - `key_file`: SSL private key file

---

## System Utilities

Miscellaneous system utilities and specialized tools.

### System Creation Tools
- [script] **`iso_to_usb.sh <device> <iso_file>`** - Create bootable USB from ISO image
  - `device`: USB device (e.g., /dev/sdb)
  - `iso_file`: ISO image file

### Requirements Management
- [script] **`get_install_requires.py <setup.py> [setup.py...]`** - Extract requirements from setup.py files
  - `setup.py`: One or more setup.py files to analyze

### Storage Management
*Available only if pumount command exists*

- [function] **`pumount-these`** - Unmount multiple removable devices

### macOS Package Management
*Available only on macOS with Homebrew*

- [function] **`brew-describe-installed`** - Show descriptions of installed Homebrew packages
- [function] **`brew-reinstall-non-casks`** - Reinstall Homebrew formula packages

---

## Shell and Prompt Customization

Tools for customizing the shell environment and prompt appearance.

### Prompt Management
- [function] **`parse_git_branch`** - Get current git branch for prompt display
- [function] **`prompt-system-default`** - Switch to system default prompt
- [function] **`prompt-verbose`** - Switch to verbose prompt with full path and git info
- [function] **`prompt-terse`** - Switch to terse prompt with minimal information
- [function] **`prompt-minimal`** - Switch to minimal prompt
- [function] **`prompt-minimal-plus`** - Switch to minimal prompt with git branch info
- [function] **`prompt-select-mode`** - Interactive prompt style selection

### Terminal Display
- [function] **`fontsize <size>`** - Change terminal font size
  - `size`: Font size number

### Visual Elements
- [function] **`draw-delimiter-line [width] [pattern] [rows]`** - Draw custom delimiter lines
  - `width`: Line width (defaults to terminal width)
  - `pattern`: Two-character pattern (defaults to "&%")
  - `rows`: Number of rows (defaults to 1)
- [function] **`draw-delimiter-line--pound [width] [rows]`** - Draw pound sign delimiters
- [function] **`draw-delimiter-line--html [width] [fill_char] [rows]`** - Draw HTML comment delimiters

---

## Example Usage and Learning

Self-documenting functions that demonstrate usage patterns from the actual codebase. These functions are only available if the base repository path is set.

### Command Usage Examples
- [function] **`example-usage--date-format-strings`** - Show date format string examples from codebase
- [function] **`example-usage--tr`** - Show tr command usage patterns
- [function] **`example-usage--cut`** - Show cut command usage patterns
- [function] **`example-usage--sort`** - Show sort command usage patterns
- [function] **`example-usage--git`** - Show git command usage patterns
- [function] **`example-usage--git-log`** - Show git log usage patterns
- [function] **`example-usage--xargs`** - Show xargs usage patterns
- [function] **`example-usage--IFS`** - Show IFS (Internal Field Separator) usage

### Text Processing Examples
- [function] **`example-usage--substitutions-perl`** - Show perl substitution patterns
- [function] **`example-usage--substitutions-sed`** - Show sed substitution patterns
- [function] **`example-usage--test-regex-match`** - Show regex matching examples

### Tool Usage Examples
- [function] **`example-usage--grepit`** - Show grepit usage patterns from codebase
- [function] **`example-usage--iterate-repos`** - Show repository iteration patterns

### Interactive Input Examples
- [function] **`example-usage--user-input-bash`** - Show bash user input patterns
- [function] **`example-usage--user-input-zsh`** - Show zsh user input patterns

---

## Tool Integration

Wrapper functions for external tools installed in the tools-py virtual environment. These functions are only available if the tools are installed in `~/tools-py/venv`.

### Python Development Tools
- [function] **`tools-py-python`** - Run Python interpreter from tools-py environment
- [function] **`asciinema`** - Terminal session recorder
- [function] **`flake8`** - Python code linting
- [function] **`flakeit`** - Filtered flake8 output excluding common warnings
- [function] **`flakeit-full`** - Complete flake8 output
- [function] **`jupyter`** - Jupyter notebook server
- [function] **`twine`** - Python package publishing

### Development and Analysis Tools
- [function] **`sql-ipython`** - SQL helper IPython environment
- [function] **`kenjyco-ipython`** - Kenjyco development IPython environment
- [function] **`grip`** - Markdown preview server
- [function] **`rdb`** - Redis RDB file analysis

### Cloud and Network Tools
- [function] **`aws`** - AWS CLI wrapper
- [function] **`http`** - HTTPie HTTP client

### Media Tools
- [function] **`yt-download`** - YouTube video downloader
- [function] **`yt-download-upgrade`** - Upgrade YouTube downloader

---

## Conditional Availability and Platform Support

### Cross-Platform Tool Aliases
*These aliases are only created on macOS when GNU tools are available*

- [alias] **`find=gfind`** - Use GNU find instead of BSD find
- [alias] **`grep=ggrep`** - Use GNU grep instead of BSD grep
- [alias] **`sort=gsort`** - Use GNU sort instead of BSD sort
- [alias] **`xargs=gxargs`** - Use GNU xargs instead of BSD xargs

### Help System Enhancement
*Available only in zsh*

- [alias] **`help=run-help`** - Enhanced help system for zsh

### Development Tool Aliases
*Available only if kenjyco-ipython function exists*

- [alias] **`ipy=kenjyco-ipython`** - Quick access to kenjyco IPython environment
