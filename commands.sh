# Source this file

# Add aliases for ..
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

cdd() { mkdir -p "$1" && cd "$1" && pwd; }

draw-delimiter-line() {
    width=$1
    two_char_pattern=$2
    rows=$3
    [[ -z "$width" || "$width" == "." ]] && width=$(($(tput cols) - 1))
    [[ -z "$two_char_pattern" ]] && two_char_pattern="&%"
    [[ -z "$rows" ]] && rows=1
    two_char_pattern=${two_char_pattern:0:2}
    [[ ${#two_char_pattern} -eq 1 ]] && two_char_pattern="${two_char_pattern}${two_char_pattern}"

    line=""
    for ((i=1; i<=width; i++)); do
        if ((i % 2 == 0)); then
            line+="${two_char_pattern:1:1}"
        else
            line+="${two_char_pattern:0:1}"
        fi
    done

    echo
    for ((r=1; r<=rows; r++)); do
        echo "$line"
    done
}

draw-delimiter-line--pound() {
    width=$1
    rows=$2
    [[ -z "$width" || "$width" == "." ]] && width=$(($(tput cols) - 1))
    [[ -z "$rows" ]] && rows=1
    draw-delimiter-line $width "#" $rows
}

draw-delimiter-line--html() {
    width=$1
    fill_char=$2
    rows=$3
    [[ -z "$width" || "$width" == "." ]] && width=$(($(tput cols) - 1))
    [[ -z "$fill_char" ]] && fill_char="@"
    [[ -z "$rows" ]] && rows=1
    fill_char=${fill_char:0:1}

    # Trim width to account for comment start and end tags
    width=$(($width - 7))
    [[ $width -lt 0 ]] && width=0

    # Set the middle content and replace spaces with another character
    middle=$(printf "%*s" $width '')
    middle=${middle// /$fill_char}

    echo
    for ((r=1; r<=rows; r++)); do
        echo "<!--${middle}-->"
    done
}


if [[ -f "$HOME/.base_path" ]]; then
    base() {
        cd $(cat "$HOME/.base_path")
    }

    base-update() {
        oldpwd=$(pwd)
        base
        echo -e "\n\nU P D A T I N G   B A S E   R E P O"
        commit_id_before=$(git reflog -1 | awk '{print $1}')
        repos-update--skip-swps
        commit_id_after=$(git reflog -1 | awk '{print $1}')
        echo -e "\n\nC U R R E N T   S T A T U S"
        repos-status
        if [[ "$commit_id_before" != "$commit_id_after" ]]; then
            install_changed=$(git log --oneline --name-status HEAD@{1}.. | grep 'install.sh')
            if [[ -n "$install_changed" ]]; then
                echo -e "\n\nB A S E   S E T U P   (install.sh was updated)"
                conflicts=$(git status -s | grep '^UU')
                if [[ -n "$conflicts" ]]; then
                    echo -e "Merge conflicts! Not running install\n$conflicts"
                else
                    install_args=
                    [[ -f "$HOME/.base_install_args" ]] && install_args=$(cat "$HOME/.base_install_args")
                    source ./install.sh $install_args
                fi
            fi
        fi
        cd "$oldpwd"
    }

    dotfiles-install() {
        base_parent=$(dirname $(cat "$HOME/.base_path"))
        git clone https://github.com/kenjyco/dotfiles "$base_parent/dotfiles"
        "$base_parent/dotfiles/setup.bash"
    }

    example-usage--date-format-strings() {
        oldpwd=$(pwd)
        base
        grepit "date +" | grep -o "\$(date +[^\)]*)" | sort | uniq -c | sort -nr
        cd "$oldpwd"
    }

    example-usage--tr() {
        oldpwd=$(pwd)
        base
        grepit '\btr\b' | grep -o "\btr [^|)]*" | sort | uniq -c | sort -nr
        cd "$oldpwd"
    }

    example-usage--cut() {
        oldpwd=$(pwd)
        base
        grepit "\bcut " | grep -o "\bcut -[^\|)]*" | sort | uniq -c | sort -nr
        cd "$oldpwd"
    }

    example-usage--sort() {
        oldpwd=$(pwd)
        base
        grepit --exclude=README.md "\bsort\b" | grep -vE ":[ ]*\b(echo|eval)\b" | grep -vE "(sort \[|APT_SECURITY)" | grep -o "| sort [^)]*" | sort | uniq -c | sort -nr
        cd "$oldpwd"
    }

    example-usage--git() {
        oldpwd=$(pwd)
        base
        grepit --exclude=README.md "\bgit " | grep -vE "(git log|clone|git &>/dev|git ###|git version|git wget|git repo|git --exclude-dir|git stash pop')" | grep -o "git [^\|]*" | sed 's/[ )]*$//' | perl -pe 's/\s*[2&]>\s*\/dev\/null$//' | sort | uniq -c | sort -nr
        cd "$oldpwd"
    }

    example-usage--git-log() {
        oldpwd=$(pwd)
        base
        grepit --exclude=README.md "\bgit log\b" | grep -v 'git log|clone' | grep -o "git log [^\|]*" | sort | uniq -c | sort -nr
        cd "$oldpwd"
    }


    example-usage--xargs() {
        oldpwd=$(pwd)
        base
        grepit --exclude=README.md "\bxargs\b" | grep -v "xargs_dash_i" | grep -o "| xargs.*" | sort | uniq -c | sort -nr
        cd "$oldpwd"
    }

    example-usage--IFS() {
        oldpwd=$(pwd)
        base
        grepit --exclude=README.md "\bIFS\b" | grep -o "IFS.*" | sort | uniq -c | sort -nr
        cd "$oldpwd"
    }

    example-usage--substitutions-perl() {
        oldpwd=$(pwd)
        base
        grepit "\bperl -" | grep -o "perl .*" | sort | uniq -c | sort -nr
        cd "$oldpwd"
    }

    example-usage--substitutions-sed() {
        oldpwd=$(pwd)
        base
        grepit "\bsed\b -" | grep -o "sed .*" | sort | uniq -c | sort -nr
        cd "$oldpwd"
    }

    example-usage--test-regex-match() {
        oldpwd=$(pwd)
        base
        grepit "=~" | grep -o "\[\[.*\]\]" | sort | uniq -c | sort -nr
        cd "$oldpwd"
    }

    example-usage--grepit() {
        oldpwd=$(pwd)
        base
        grepit --exclude=README.md "grepit " | grep -vE "(grepit #|# grepit|grepit to handle)" | grep -o "grepit .*" | sort | uniq -c | sort -nr
        cd "$oldpwd"
    }

    # example-usage--findit() {
    #     oldpwd=$(pwd)
    #     base
    #     (grepit --exclude=README.md "findit " | grep -vE "(findit #|# findit|echo ['\"] *findit|findit --help|Usage: findit|eval \"findit|\\\$.findit)" | grep -o "findit .*"
    #     grepit --exclude=README.md "findit " | grep -vE "(findit #|# findit|echo ['\"] *findit|findit --help|Usage: findit|eval \"findit)" | grep -o "\$(findit .*"
    #     grepit --exclude=README.md "^ *echo .*findit " | grep -v "Usage: findit" | grep -o "findit .*") |
    #        sort | uniq -c | sort -nr

    #     cd "$oldpwd"
    # }

    example-usage--iterate-repos() {
        oldpwd=$(pwd)
        base
        grepit "for repo in \$(" | grep -o "for repo in .*" | sort | uniq -c | sort -nr
        cd "$oldpwd"
    }

    example-usage--user-input-bash() {
        oldpwd=$(pwd)
        base
        grepit "read -p" | grep -o "read -p .*" | sort | uniq -c | sort -nr
        cd "$oldpwd"
    }

    example-usage--user-input-zsh() {
        oldpwd=$(pwd)
        base
        grepit "vared -p" | grep -o "vared -p .*" | sort | uniq -c | sort -nr
        cd "$oldpwd"
    }

fi
if [[ -f "$HOME/.dotfiles_path" ]]; then
    dotfiles() {
        cd $(cat "$HOME/.dotfiles_path")
    }

    dotfiles-update() {
        oldpwd=$(pwd)
        dotfiles
        echo -e "\n\nU P D A T I N G   D O T F I L E S   R E P O"
        commit_id_before=$(git reflog -1 | awk '{print $1}')
        repos-update--skip-swps
        commit_id_after=$(git reflog -1 | awk '{print $1}')
        echo -e "\n\nC U R R E N T   S T A T U S"
        repos-status
        if [[ "$commit_id_before" != "$commit_id_after" ]]; then
            setup_changed=$(git log --oneline --name-status HEAD@{1}.. | grep 'setup.bash')
            if [[ -n "$setup_changed" ]]; then
                echo -e "\n\nD O T F I L E S   S E T U P   (setup.bash was updated)"
                conflicts=$(git status -s | grep '^UU')
                if [[ -n "$conflicts" ]]; then
                    echo -e "Merge conflicts! Not running install\n$conflicts"
                else
                    bash ./setup.bash
                fi
            fi
        fi
        cd "$oldpwd"
    }
fi

# Use GNU find, grep, sort, and xargs if on a Mac
if [[ $(uname) == "Darwin" ]]; then
    if type gfind &>/dev/null; then
        alias find=gfind
    fi
    if type ggrep &>/dev/null; then
        alias grep=ggrep
    fi
    if type gsort &>/dev/null; then
        alias sort=gsort
    fi
    if type gxargs &>/dev/null; then
        alias xargs=gxargs
    fi
fi

if find . -maxdepth 1 -type f -executable &>/dev/null; then
    find_executables=yes
fi

if echo | grep -P '' &>/dev/null; then
    grep_perl=yes
fi

if [[ -d /opt/homebrew/bin ]]; then
    if [[ -z "$(echo $PATH | grep /opt/homebrew/bin)" ]]; then
        export PATH="/opt/homebrew/bin:$PATH"
    fi
fi

#################### bash/zsh setup ####################

# Function to get name of current git branch
parse_git_branch() {
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

if [[ -n "$BASH_VERSION" ]]; then
    # Enable tab-completion
    if [[ -f /etc/bash_completion ]]; then
        source /etc/bash_completion
    elif [[ -f /usr/local/etc/bash_completion ]]; then
        source /usr/local/etc/bash_completion
    elif [[ -f /usr/share/bash-completion/bash_completion ]]; then
        source /usr/share/bash-completion/bash_completion
    else
        fname=$(brew --prefix 2>/dev/null)/etc/bash_completion
        [[ -f "$fname" ]] && source "$fname"
    fi

    # Tab-completion for SSH
    _complete_ssh_hosts ()
    {
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        comp_ssh_hosts=`cat ~/.ssh/known_hosts 2>/dev/null | \
            grep -vE '^(\||\[|#)' | \
            cut -f 1 -d ' ' | \
            cut -f 1 -d ',' | \
            grep -v ':' | \
            uniq ;
        cat ~/.ssh/config 2>/dev/null | \
            grep "^Host " | \
            awk '{print $2}'`
        COMPREPLY=( $(compgen -W "${comp_ssh_hosts}" -- $cur))
        return 0
    }
    complete -F _complete_ssh_hosts ssh

    # Use vi keybindings to navigate command line
    set -o vi

    # Append to history file instead of overwriting
    shopt -s histappend

    # Don't add duplicate lines, or lines starting with a space to the history file
    HISTCONTROL=ignoreboth

    # Set number of commands stored in memory and in the history file
    HISTSIZE=50000
    HISTFILESIZE=50000
    HISTFILE=$HOME/.history_bash

    # Update values of LINES and COLUMNS after window resize
    shopt -s checkwinsize

    # Use '**' in pathname expansions like in ZSH
    #   - super old versions of bash like 3.2 say globstar is an "invalid shell
    #     option name"
    [[ $(echo $BASH_VERSION | cut -c 1-1) -ge 4 ]] && shopt -s globstar

    # Save original prompt
    _PS1_ORIG="$PS1"

    # Add function to switch to the default prompt
    prompt-system-default() {
        PS1="$_PS1_ORIG"
    }

    # Add function to switch to a verbose prompt
    prompt-verbose() {
        PS1="\n\[\e[1;32m\]\u@\h:\[\e[0m\]\w\[\e[1;32m\]\$(parse_git_branch)\n\[\e[1;33m\]\$ \[\e[0m\]"
    }

    # Add function to switch to a terse prompt
    prompt-terse() {
        PS1="[\h] \[\e[1;33m\]\[\e[1;33m\]\W\[\e[1;32m\]\$(parse_git_branch) \$\[\e[0m\] "
    }

    # Add function to switch to a minimal prompt
    prompt-minimal() {
        PS1="\n\$ "
    }

    # Add function to switch to a minimal prompt that includes dirname/git info
    prompt-minimal-plus() {
        PS1="\n\[\e[1;33m\]\[\e[1;33m\]\W\[\e[1;32m\]\$(parse_git_branch) \$\[\e[0m\] "
    }

elif [[ -n "$ZSH_VERSION" ]]; then
    # Set tab completion and matching options
    zstyle ':completion:*' completer _expand _complete _ignored _approximate
    zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**'
    zstyle ':completion:*' rehash true
    autoload -Uz compinit
    compinit -i

    # Set number of commands stored in memory and in the history file
    HISTSIZE=50000
    SAVEHIST=50000
    HISTFILE=$HOME/.history_zsh

    # Enable bash-style comments at command line and extended zsh globbing
    setopt interactivecomments extendedglob

    # Disable reporting an error when filename glob has no matches
    setopt null_glob

    # Use vi keybindings to navigate command line
    bindkey -v

    # Append to history file and save command's beginning timestamp/duration
    setopt appendhistory extendedhistory

    # Don't add duplicate lines, or lines starting with a space to the history file
    setopt histignoredups histignorespace

    # Search through command history with ^r like bash (in vi insert mode)
    bindkey -M viins '^R' history-incremental-search-backward
    bindkey -M viins '^S' history-incremental-search-forward

    # Search through command history with vi search keys (in vi command mode)
    bindkey -M vicmd '?' history-incremental-pattern-search-backward
    bindkey -M vicmd '/' history-incremental-pattern-search-forward

    # Set help
    unalias run-help 2>/dev/null
    autoload -Uz run-help
    HELPDIR=$(find /usr/share/zsh -type d -name help)
    alias help=run-help

    # Enable fish-style syntax highlighting
    if [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
        source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    elif [[ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
        source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    fi

    autoload -U colors && colors
    setopt PROMPT_SUBST

    # Save original prompt
    _PROMPT_ORIG="$PROMPT"

    # Add function to switch to the default prompt
    prompt-system-default() {
        PROMPT="$_PROMPT_ORIG"
    }

    # Add function to switch to a verbose prompt
    prompt-verbose() {
        PROMPT="
%{$fg_bold[green]%}%n@%m:%{$fg[white]%}%~%{$fg[green]%}\$(parse_git_branch)
%{$fg[yellow]%}%# %{$reset_color%}"
    }

    # Add function to switch to a terse prompt
    prompt-terse() {
         PROMPT="[%m] %{$fg_bold[yellow]%}%c%{$fg[green]%}\$(parse_git_branch) %# %{$reset_color%}"
    }

    # Add function to switch to a minimal prompt
    prompt-minimal() {
         PROMPT="
%# "
    }

    # Add function to switch to a minimal prompt that includes dirname/git info
    prompt-minimal-plus() {
         PROMPT="
%{$fg_bold[yellow]%}%c%{$fg[green]%}\$(parse_git_branch) %# %{$reset_color%}"
    }
fi

prompt-select-mode() {
    echo "Select prompt mode"
    choices=(system-default verbose terse minimal minimal-plus)
    select choice in "${choices[@]}"; do
        echo "$choice" > $HOME/.selected_prompt_mode
        break
    done

    if [[ "$choice" = "system-default" ]]; then
        prompt-system-default
    elif [[ "$choice" = "verbose" ]]; then
        prompt-verbose
    elif [[ "$choice" = "terse" ]]; then
        prompt-terse
    elif [[ "$choice" = "minimal" ]]; then
        prompt-minimal
    elif [[ "$choice" = "minimal-plus" ]]; then
        prompt-minimal-plus
    fi
}

#################### completions ####################

bash_completion_dir="$(brew --prefix 2>/dev/null)/etc/bash_completion.d"
bash_completion_file="$(dirname $bash_completion_dir)/bash_completion"
if [[ $(uname) != "Darwin" && -z "$(groups | grep -E '(sudo|root|admin|wheel)')" ]]; then
    bash_completion_dir="$HOME/.downloaded-completions"
    mkdir -p "$bash_completion_dir" 2>/dev/null
    bash_completion_file="$HOME/.bash_completion"
fi
if [[ ! -s "$bash_completion_file" ]]; then
    [[ -f /usr/share/bash-completion/bash_completion ]] && bash_completion_file=/usr/share/bash-completion/bash_completion
fi

_get_zsh_custom_fpath() {
    [[ -z "$ZSH_VERSION" ]] && return

    # Determine if there is a custom dir in $fpath already, or make $HOME/.zsh/completions
    custom_fpaths=()
    for some_path in "${fpath[@]}"; do
        if [[ "${some_path:0:11}" != "/usr/local/" && "${some_path:0:11}" != "/usr/share/" ]]; then
            custom_fpaths+=("$some_path")
        fi
    done
    if [[ -n "$custom_fpaths" ]]; then
        custom_fpath="${custom_fpaths[1]}"
    else
        custom_fpath="$HOME/.zsh/completion"
    fi
    if [[ ! -d "$custom_fpath" ]]; then
        echo -e "\n$ mkdir -pv $custom_fpath"
        mkdir -pv "$custom_fpath"
    fi
    echo "$custom_fpath"
}

# Make sure bash/zsh (tab) completions are enabled for docker and git
get-completions() {
    custom_fpath="$(_get_zsh_custom_fpath)"
    [[ -z "$custom_fpath" ]] && custom_fpath="$HOME/.zsh/completion"

    if [[ "$1" == "clean" ]]; then
        if [[ ! "$bash_completion_dir" =~ ${HOME}.* && ! "$bash_completion_dir" =~ \/root\/.* ]]; then
            if [[ -n "$(groups | grep -E '(sudo|root|admin|wheel)')" ]]; then
                echo -e "\nDeleting any docker/git files from $bash_completion_dir"
                sudo rm -f $bash_completion_dir/docker $bash_completion_dir/docker-compose $bash_completion_dir/git-completion.bash 2>/dev/null
            fi
        else
            echo -e "\nDeleting any docker/git files from $bash_completion_dir"
            rm -f $bash_completion_dir/docker $bash_completion_dir/docker-compose $bash_completion_dir/git-completion.bash 2>/dev/null
        fi

        echo -e "\nDeleting any docker/git files from $custom_fpath"
        rm -f "$custom_fpath/_docker" "$custom_fpath/_docker-compose" "$custom_fpath/git-completion.zsh" 2>/dev/null
    fi

    git_version=$(git --version 2>/dev/null | perl -pe 's/^git version (\S+).*$/$1/')
    docker_version=$(docker --version 2>/dev/null | perl -pe 's/^Docker version (\S+),.*/$1/')
    zsh_urls=()
    bash_urls=()
    if [[ -n "$git_version" ]]; then
        zsh_urls+=(https://raw.githubusercontent.com/git/git/v$git_version/contrib/completion/git-completion.zsh)
        bash_urls+=(https://raw.githubusercontent.com/git/git/v$git_version/contrib/completion/git-completion.bash)
    fi
    if [[ -n "$docker_version" ]]; then
        zsh_urls+=(https://raw.githubusercontent.com/docker/cli/v$docker_version/contrib/completion/zsh/_docker)
        bash_urls+=(https://raw.githubusercontent.com/docker/cli/v$docker_version/contrib/completion/bash/docker)

        # Note: older versions of docker did not include a 'compose' command, so
        # docker-compose was a separately installed script which also had it's own
        # completion file
        is_docker_old=$(docker compose version 2>&1 | grep 'not a docker command')
        if [[ -n "$is_docker_old" ]]; then
            docker_compose_version=$(docker-compose --version 2>/dev/null | perl -pe 's/^docker-compose version (\S+),.*/$1/')
            if [[ -n "$docker_compose_version" ]]; then
                zsh_urls+=(https://raw.githubusercontent.com/docker/compose/$docker_compose_version/contrib/completion/zsh/_docker-compose)
                bash_urls+=(https://raw.githubusercontent.com/docker/compose/$docker_compose_version/contrib/completion/bash/docker-compose)
            fi
        fi
    fi
    if [[ -n "$ZSH_VERSION" ]]; then
        # Copy the completion files
        for url in "${zsh_urls[@]}"; do
            fname=$(basename "$url")
            if [[ ! -f ${custom_fpath}/$fname ]]; then
                echo -e "\n$ curl -L $url > ${custom_fpath}/$fname"
                curl -L "$url" > "${custom_fpath}/$fname" || return 1
            fi
        done
    elif [[ -n "$BASH_VERSION" ]]; then
        # Make sure bash-completion package is installed
        if [[ $(uname) == "Darwin" ]]; then
            if ! type brew &>/dev/null; then
                echo -e "\nHomebrew not found"
                return 1
            fi
            brew_completions=$(brew list bash-completion 2>/dev/null)
            if [[ -z "$brew_completions" ]]; then
                echo -e "\n$ brew install bash-completion"
                brew install bash-completion || return 1
            fi
        elif [[ -f /usr/bin/apt-get && -n "$(groups | grep -E '(sudo|root)')" ]]; then
            echo -e "\n$ sudo apt-get install -y bash-completion"
            sudo apt-get install -y bash-completion
        fi
        # Copy the completion files
        if [[ "$bash_completion_dir" =~ ${HOME}.* || "$bash_completion_dir" =~ \/root\/.* ]]; then
            for url in "${bash_urls[@]}"; do
                fname=$(basename "$url")
                if [[ ! -f $bash_completion_dir/$fname ]]; then
                    echo -e "\n$ curl -L $url > \"$bash_completion_dir/$fname\""
                    curl -L $url > "$bash_completion_dir/$fname" || return 1
                fi
            done
            cat "$bash_completion_dir"/* > "$bash_completion_file"
        else
            for url in "${bash_urls[@]}"; do
                fname=$(basename "$url")
                if [[ ! -f $bash_completion_dir/$fname ]]; then
                    echo -e "\n$ sudo sh -c \"curl -L $url > $bash_completion_dir/$fname\""
                    sudo sh -c "curl -L $url > $bash_completion_dir/$fname" || return 1
                fi
            done
        fi
    fi
}

# Prompt user to see if they want to update any completions they have setup for their shell
custom_fpath="$(_get_zsh_custom_fpath)"
unset yn
if [[ -n "$BASH_VERSION" ]]; then
    if [[ ! -f $bash_completion_dir/git-completion.bash && -n "$BASE_INSTALL_INTERACTIVE_MODE" ]]; then
        read -p "Update completions for bash? [y/n] " yn
        [[ "$yn" =~ [yY].* ]] && get-completions
    fi
    source "$bash_completion_file"
elif [[ -n "$ZSH_VERSION" ]]; then
    if [[ ! -f "$custom_fpath/git-completion.zsh" && -n "$BASE_INSTALL_INTERACTIVE_MODE" ]]; then
        vared -p "Update completions for zsh? [y/n] " -c yn
        [[ "$yn" =~ [yY].* ]] && get-completions
    fi
    [[ -z "$(echo ${fpath[@]} | grep $custom_fpath)" ]] && fpath=($custom_fpath $fpath)
    compinit -i
fi

#################### Environment managers ####################

rust-install() {
    if type rustup &>/dev/null; then
        rustup update
    else
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    fi
}

gvm-install() {
    if [[ "$1" == "clean" && -d ~/.nvm ]]; then
        echo -e "\nDeleting ~/.gvm"
        rm -rf ~/.gvm 2>/dev/null
    fi

    if ! type bison &>/dev/null; then
        if [[ -f /usr/bin/apt-get && -n "$(groups | grep -E '(sudo|root)')" ]]; then
            sudo apt-get install -y bison
        elif [[ -f /usr/bin/yum && -n "$(groups | grep -E '(sudo|root|wheel)')" ]]; then
            sudo yum install -y bison
        fi
    fi

    if [[ ! -d ~/.gvm ]]; then
        echo -e "\nInstalling gvm using the gvm-installer script on github..."
        bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)
    fi
    source "$HOME/.gvm/scripts/gvm"

    if ! type go &>/dev/null; then
        if [[ $(uname) == "Darwin" ]]; then
            brew install go
        elif [[ -f /usr/bin/apt-get && -n "$(groups | grep -E '(sudo|root)')" ]]; then
            sudo apt-get install -y golang-go
        elif [[ -f /usr/bin/yum && -n "$(groups | grep -E '(sudo|root|wheel)')" ]]; then
            sudo yum install -y golang
        fi
    fi

    go_minor_version=$(go version 2>/dev/null | perl -pe 's/^go version go\d\.(\d+)\..*/$1/')
    if [[ -n "$go_minor_version" && "$go_minor_version" -lt 17 ]]; then
        gvm install go1.17 || return 1
        gvm use go1.17
        export GOROOT_BOOTSTRAP=$GOROOT
        gvm install go1.20
        unset GOROOT_BOOTSTRAP
    elif [[ -n "$go_minor_version" && "$go_minor_version" -lt 20 ]]; then
        gvm install go1.20
    fi
}

# Enable gvm (go version manager)
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm" 2>/dev/null

if type go &>/dev/null; then
    go-version() {
        go version | perl -pe 's/^go version go(\S+) .*$/$1/'
    }

    go-minor-version() {
        go version | perl -pe 's/^go version go\d\.(\d+)\..*/$1/'
    }
fi

if type gvm &>/dev/null; then
    gvm-list-installable() {
        gvm listall | grep ' *go1\.[0-9.]*$'
    }

    gvm-list-installable-all() {
        gvm listall
    }

    gvm-list-versions-installed() {
        ls -1 ~/.gvm/gos
    }

    gvm-install-latest-go() {
        latest_version=$(gvm-list-installable | tail -n 1 | grep -o 'go.*')
        latest_installed=$(gvm-list-versions-installed | tail -n 1)
        gvm use $latest_installed
        export GOROOT_BOOTSTRAP=$GOROOT
        gvm install $latest_version || return 1
        gvm use $latest_version --default
        unset GOROOT_BOOTSTRAP
    }
fi

nvm-install() {
    if [[ "$1" == "clean" && -d ~/.nvm ]]; then
        echo -e "\nDeleting ~/.nvm and ~/.npm"
        rm -rf ~/.nvm ~/.npm 2>/dev/null
        unset NVM_DIR
    fi

    if [[ ! -d ~/.nvm ]]; then
        echo -e "\nInstalling nvm, latest 'long term support' version of node, and yarn..."
        unset NVM_DIR
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        source "$NVM_DIR/nvm.sh"
        source "$NVM_DIR/bash_completion"
        nvm install --lts
        npm install -g yarn
    fi
}

# Enable nvm (node version manager)
if [[ -d $HOME/.nvm && -z "$NVM_DIR" ]]; then
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh"
    source "$NVM_DIR/bash_completion"
fi

pyenv-install() {
    if [[ "$1" == "clean" ]]; then
        if [[ -d ~/.pyenv ]]; then
            echo -e "\nDeleting ~/.pyenv"
            rm -rf ~/.pyenv
        fi
        if [[ $(uname) == "Darwin" ]]; then
            brew uninstall pyenv
        fi
    fi

    if [[ $(uname) == "Darwin" ]]; then
        brew install pyenv
        eval "$(pyenv init -)"
    elif [[ ! -d ~/.pyenv ]]; then
        echo -e "\nInstalling pyenv..."
        git clone https://github.com/pyenv/pyenv.git ~/.pyenv
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)"
    fi
    echo -e "\n$(pyenv --version) is installed and ready to use"
    echo -e "\nInstall a particular version of Python with the following:"
    echo -e "\npyenv install 3.9.9"
}

# Prep pyenv (on linux)
if [[ $(uname) != "Darwin" && -d $HOME/.pyenv && -z "$PYENV_ROOT" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
fi

# Enable pyenv (on linux/mac)
if type pyenv &>/dev/null; then
    eval "$(pyenv init -)"
    if [[ -z "$(echo $PATH | grep pyenv/shims)" ]]; then
        export PATH="$HOME/.pyenv/shims:$PATH"
    fi

    pyenv-list-installable() {
        pyenv install --list | grep '^  [2-4]\.[0-9.]*$'
    }

    pyenv-list-grep() {
        arg=${1-'^  [2-4]'}
        pyenv install --list | grep $arg
    }

    pyenv-list-installable-all() {
        pyenv install --list
    }

    pyenv-list-versions-installed() {
        ls -1 ~/.pyenv/versions
    }

    pyenv-list-python-version-files() {
        findit --type f --pattern ".python-version"
    }

    pyenv-install-latest-python() {
        latest_version=$(pyenv-list-installable | tail -n 1 | grep -o '[3-4].*')
        pyenv install $latest_version
    }

    tools-py-create-venv-from-pyenv-version() {
        unset choice yn
        py_versions=($(ls -1d ~/.pyenv/versions/* | grep -v '^\.$'))
        if [[ -n "$py_versions" ]]; then
            if [[ ${#py_versions[@]} -eq 1 ]]; then
                choice=$py_versions
            else
                select choice in "${py_versions[@]}"; do
                    break
                done
            fi
            [[ -z "$choice" ]] && return 1
        else
            echo "No python versions installed via pyenv yet!"
            echo "Use 'pyenv-list-installable' to show available versions, then"
            echo -e "\n    pyenv install 3.x.y"
            return 1
        fi

        if [[ -d "$HOME/tools-py/venv" ]]; then
            if [[ -n "$BASH_VERSION" ]]; then
                read -p "Replace existing $HOME/tools-py-venv? [y/n] " yn
            elif [[ -n "$ZSH_VERSION" ]]; then
                vared -p "Replace existing $HOME/tools-py-venv? [y/n] " -c yn
            fi
            [[ ! "$yn" =~ [yY].* ]] && return
            rm -rf "$HOME/tools-py/venv"
        fi

        echo "$ ${choice}/bin/python -m venv $HOME/tools-py/venv"
        ${choice}/bin/python -m venv "$HOME/tools-py/venv"
        source $HOME/commands.sh
    }
fi

#################### Package management (non-sudo) ####################

if type apt-cache &>/dev/null; then
    acs() {
        apt-cache search $1 | grep -i "^$1"
    }

    acs2() {
        apt-cache search $1 | grep -i "\b$1\b"
    }

    upgradable() {
        apt list --upgradable
    }

    apt-sources() {
        cat /etc/apt/sources.list /etc/apt/sources.list.d/*
    }
fi

if type yum &>/dev/null; then
    yum-search() {
        yum search $1 | grep -i "^$1"
    }
fi

manually-installed() {
    if [[ -d /var/log/apt ]]; then
        cat /var/log/apt/history.log <(zcat /var/log/apt/history.log.*) | grep -E '(apt-get|apt) install' | sort -u
    elif type brew &>/dev/null; then
        brew list
    else
        for hist_num in $(yum history --reverse | awk '{print $1}' | grep '^[0-9]'); do
            echo
            yum history info $hist_num | grep -E '^(Command Line|Return-Code)'
        done
    fi
}

#################### Tools ####################

_postgresql-install() {
    if ! type pg_config &>/dev/null; then
        if type apt-get &>/dev/null; then
            sudo apt-get install -y libpq-dev || return 1
        elif type brew &>/dev/null; then
            brew install postgresql || return 1
        elif type yum &>/dev/null; then
            sudo yum install -y libpq-devel || return 1
        else
            echo -e "\nNot sure how to install postgresql for your system."
            echo "You need to get the pg_config executable"
            return 1
        fi
    fi
}

tools-py-pip-install() {
    [[ ! -d "$HOME/tools-py/venv" ]] && python3 -m venv "$HOME/tools-py/venv" && "$HOME/tools-py/venv/bin/pip3" install --upgrade pip wheel
    "$HOME/tools-py/venv/bin/pip3" install "$@"
}

tools-py-install-all() {
    [[ "$1" == "clean" ]] && rm -rf "$HOME/tools-py"
    [[ ! -d "$HOME/tools-py/venv" ]] && python3 -m venv "$HOME/tools-py/venv" && "$HOME/tools-py/venv/bin/pip3" install --upgrade pip wheel
    yt-download-install
    mocplayer-install
    package_names=(asciinema awscli flake8 twine httpie yt-helper ipython jupyter grip rdbtools python-lzf pytest)
    _postgresql-install && package_names+=(sql-helper)
    "$HOME/tools-py/venv/bin/pip3" install ${package_names[@]}
}

if [[ -s "$HOME/tools-py/venv/bin/python" ]]; then
    tools-py-python() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/python "$@"
    }

    if type pyenv &>/dev/null; then
        pyenv-pip-versions() {
            tools-py-python -c 'import bg_helper as bh; from pprint import pprint; pprint(bh.tools.pyenv_pip_versions())'
        }

        pyenv-package-versions() {
            tools-py-python -c 'import bg_helper as bh; bh.tools.pyenv_pip_package_versions_available("'$1'", show=True)'
        }

        pyenv-select-python-versions-to-install() {
            tools-py-python -c 'import bg_helper as bh; bh.tools.pyenv_select_python_versions_to_install()'
        }
    fi
fi

asciinema-install() {
    [[ ! -d "$HOME/tools-py/venv" ]] && python3 -m venv "$HOME/tools-py/venv" && "$HOME/tools-py/venv/bin/pip3" install --upgrade pip wheel
    "$HOME/tools-py/venv/bin/pip3" install asciinema
    source $HOME/commands.sh
}

if [[ -s "$HOME/tools-py/venv/bin/asciinema" ]]; then
    asciinema() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/asciinema "$@"
    }
fi

if type asciinema &>/dev/null; then
    asciicast() {
        title=$1
        now_string="$(date +'%Y_%m%d-%a-%H%M%S')"
        if [[ -z "$title" ]]; then
            title="misc--${now_string}"
        else
            title="${title}--${now_string}"
        fi
        fname="$title.json"

        tmux -2 new-session -s cast -d
        asciinema rec -c "tmux attach-session -t cast" -i 2 -t "$title" "$fname"
        echo -e "Saved recording to $fname"
    }

    asciicast-no-tmux() {
        title=$1
        now_string="$(date +'%Y_%m%d-%a-%H%M%S')"
        if [[ -z "$title" ]]; then
            title="misc--${now_string}"
        else
            title="${title}--${now_string}"
        fi
        fname="$title.json"

        asciinema rec -i 2 -t "$title" "$fname"
        echo -e "Saved recording to $fname"
    }
fi

aws-install() {
    [[ ! -d "$HOME/tools-py/venv" ]] && python3 -m venv "$HOME/tools-py/venv" && "$HOME/tools-py/venv/bin/pip3" install --upgrade pip wheel
    "$HOME/tools-py/venv/bin/pip3" install awscli
    source $HOME/commands.sh
}

if [[ -s "$HOME/tools-py/venv/bin/aws" ]]; then
    aws() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/aws "$@"
    }
fi

flake8-install() {
    [[ ! -d "$HOME/tools-py/venv" ]] && python3 -m venv "$HOME/tools-py/venv" && "$HOME/tools-py/venv/bin/pip3" install --upgrade pip wheel
    "$HOME/tools-py/venv/bin/pip3" install flake8
    source $HOME/commands.sh
}

if [[ -s "$HOME/tools-py/venv/bin/flake8" ]]; then
    flake8() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/flake8 "$@"
    }

    flakeit() {
        flake8 --exclude='venv/*' . |
        grep -Ev "(line too long|import not at top of file|imported but unused|do not assign a lambda|do not use bare 'except')"
    }

    flakeit-full() {
        flake8 --exclude='venv/*' .
    }
fi

sql-install() {
    [[ ! -d "$HOME/tools-py/venv" ]] && python3 -m venv "$HOME/tools-py/venv" && "$HOME/tools-py/venv/bin/pip3" install --upgrade pip wheel
    _postgresql-install && "$HOME/tools-py/venv/bin/pip3" install sql-helper
    source $HOME/commands.sh
}

if [[ -s "$HOME/tools-py/venv/bin/sql-ipython" ]]; then
    sql-ipython() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/sql-ipython "$@"
    }
fi

if [[ -s "$HOME/tools-py/venv/bin/rh-shell" ]]; then
    rh-shell() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/rh-shell "$@"
    }
fi

if [[ -s "$HOME/tools-py/venv/bin/rh-notes" ]]; then
    rh-notes() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/rh-notes "$@"
    }
fi

if [[ -s "$HOME/tools-py/venv/bin/rh-collection-reports" ]]; then
    rh-collection-reports() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/rh-collection-reports "$@"
    }
fi

if [[ -s "$HOME/tools-py/venv/bin/rh-clear-all-locks" ]]; then
    rh-clear-all-locks() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/rh-clear-all-locks "$@"
    }
fi

if [[ ! -s "$HOME/tools-py/venv/bin/kenjyco-dev-setup" ]]; then
    kenjyco-install-dev-setup() {
        [[ ! -d "$HOME/tools-py/venv" ]] && python3 -m venv "$HOME/tools-py/venv" && "$HOME/tools-py/venv/bin/pip3" install --upgrade pip wheel
        if [[ "$1" == "full" ]]; then
            "$HOME/tools-py/venv/bin/pip3" install "kenjyco-libs[full]" awscli pdbpp
        else
            "$HOME/tools-py/venv/bin/pip3" install kenjyco-libs
        fi
        "$HOME/tools-py/venv/bin/kenjyco-dev-setup"
        source $HOME/commands.sh
    }
fi

if [[ -s "$HOME/tools-py/venv/bin/kenjyco-ipython" ]]; then
    if [[ -s "$HOME/tools-py/venv/bin/ipython" ]]; then
        kenjyco-ipython() {
            PYTHONPATH=$HOME $HOME/tools-py/venv/bin/kenjyco-ipython "$@"
        }
        alias ipy=kenjyco-ipython
    fi

    kenjyco-dev-setup() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/kenjyco-dev-setup "$@"
    }

    kenjyco-full-update() {
        "$HOME/tools-py/venv/bin/pip3" install "kenjyco-libs[full]" awscli pdbpp
        "$HOME/tools-py/venv/bin/kenjyco-dev-setup"
        source $HOME/commands.sh
    }

    [[ -z "$PACKAGE_REPOS_DIR" && -d "$HOME/repos/personal/packages" ]] && PACKAGE_REPOS_DIR="$HOME/repos/personal/packages"

    if [[ -n "$PACKAGE_REPOS_DIR" && -d "$PACKAGE_REPOS_DIR" ]]; then
        if ! type package-repos &>/dev/null; then
            package-repos() {
                cd "$PACKAGE_REPOS_DIR"
            }

            if [[ -s "$HOME/tools-py/venv/bin/pytest" ]]; then
                kenjyco-pytest() {
                    oldpwd=$(pwd)
                    packages=(input-helper dt-helper mongo-helper redis-helper settings-helper sql-helper)
                    for package in "${packages[@]}"; do
                        package_dir="$PACKAGE_REPOS_DIR/$package"
                        [[ ! -d "$package_dir" ]] && continue
                        echo -e "\n\n%%%%%%%%%%%%%%%\n  $(echo $package | tr '[a-z]' '[A-Z]')\n%%%%%%%%%%%%%%%"
                        cd "$package_dir"
                        "$HOME/tools-py/venv/bin/pytest" -vs -rsfe
                    done
                    cd "$oldpwd"
                }

                kenjyco-pytest-pdb() {
                    oldpwd=$(pwd)
                    packages=(input-helper dt-helper mongo-helper redis-helper settings-helper sql-helper)
                    for package in "${packages[@]}"; do
                        package_dir="$PACKAGE_REPOS_DIR/$package"
                        [[ ! -d "$package_dir" ]] && continue
                        echo -e "\n\n%%%%%%%%%%%%%%%\n  $(echo $package | tr '[a-z]' '[A-Z]')\n%%%%%%%%%%%%%%%"
                        cd "$package_dir"
                        "$HOME/tools-py/venv/bin/pytest" -vsx -rsfe --showlocals --pdb
                    done
                    cd "$oldpwd"
                }
            fi

            kenjyco-usage-across-packages() {
                oldpwd=$(pwd)
                echo -e "\n$ package-repos"
                package-repos
                echo -e "\n$ grep-object-info-no-tests bh"
                grep-object-info-no-tests bh
                draw-delimiter-line
                echo -e "\n$ grep-object-info-no-tests fh"
                grep-object-info-no-tests fh
                draw-delimiter-line
                echo -e "\n$ grep-object-info-no-tests ih"
                grep-object-info-no-tests ih
                draw-delimiter-line
                echo -e "\n$ grep-object-info-no-tests sh"
                grep-object-info-no-tests sh
                draw-delimiter-line
                echo -e "\n$ grep-object-info-no-tests ah"
                grep-object-info-no-tests ah
                draw-delimiter-line
                echo -e "\n$ grep-object-info-no-tests dh"
                grep-object-info-no-tests dh
                draw-delimiter-line
                echo -e "\n$ grep-object-info-no-tests rh"
                grep-object-info-no-tests rh
                draw-delimiter-line
                echo -e "\n$ grep-object-info-no-tests wh"
                grep-object-info-no-tests wh
                draw-delimiter-line
                cd "$oldpwd"
            }

            kenjyco-help() {
                oldpwd=$(pwd)
                echo -e "\n$ package-repos"
                package-repos
                if [[ -s "libs/kenjyco_libs/scripts/shell.py" ]]; then
                    echo -e "\n$ cat libs/kenjyco_libs/scripts/shell.py"
                    cat libs/kenjyco_libs/scripts/shell.py
                    draw-delimiter-line
                fi
                if [[ -s "libs/README.md" ]]; then
                    echo -e "\n$ cat libs/README.md"
                    cat libs/README.md
                    draw-delimiter-line
                fi
            }
        fi
    fi

fi

twine-install() {
    [[ ! -d "$HOME/tools-py/venv" ]] && python3 -m venv "$HOME/tools-py/venv" && "$HOME/tools-py/venv/bin/pip3" install --upgrade pip wheel
    "$HOME/tools-py/venv/bin/pip3" install twine
    source $HOME/commands.sh
}

if [[ -s "$HOME/tools-py/venv/bin/twine" ]]; then
    twine() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/twine "$@"
    }
fi

http-install() {
    [[ ! -d "$HOME/tools-py/venv" ]] && python3 -m venv "$HOME/tools-py/venv" && "$HOME/tools-py/venv/bin/pip3" install --upgrade pip wheel
    "$HOME/tools-py/venv/bin/pip3" install httpie
    source $HOME/commands.sh
}

if [[ -s "$HOME/tools-py/venv/bin/http" ]]; then
    http() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/http "$@"
    }
fi

yt-download-install() {
    [[ ! -d "$HOME/tools-py/venv" ]] && python3 -m venv "$HOME/tools-py/venv" && "$HOME/tools-py/venv/bin/pip3" install --upgrade pip wheel
    "$HOME/tools-py/venv/bin/pip3" install yt-helper
    [[ -d "$PACKAGE_REPOS_DIR/yt-helper" ]] && "$HOME/tools-py/venv/bin/pip3" install -e "$PACKAGE_REPOS_DIR/yt-helper"
    [[ ! -d "$HOME/tools-py/youtube-dl" ]] && git clone https://github.com/ytdl-org/youtube-dl "$HOME/tools-py/youtube-dl"
    "$HOME/tools-py/venv/bin/pip3" install -e "$HOME/tools-py/youtube-dl"
    source $HOME/commands.sh
}

if [[ -s "$HOME/tools-py/venv/bin/yt-download" ]]; then
    yt-download() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/yt-download "$@"
    }

    yt-download-upgrade() {
        "$HOME/tools-py/venv/bin/pip3" install yt-helper --upgrade --upgrade-strategy eager
        [[ -d "$PACKAGE_REPOS_DIR/yt-helper" ]] && "$HOME/tools-py/venv/bin/pip3" install -e "$PACKAGE_REPOS_DIR/yt-helper"
        [[ ! -d "$HOME/tools-py/youtube-dl" ]] && git clone https://github.com/ytdl-org/youtube-dl "$HOME/tools-py/youtube-dl"
        cd "$HOME/tools-py/youtube-dl"
        git pull
        cd -
    }
fi

mocplayer-install() {
    [[ ! -d "$HOME/tools-py/venv" ]] && python3 -m venv "$HOME/tools-py/venv" && "$HOME/tools-py/venv/bin/pip3" install --upgrade pip wheel
    "$HOME/tools-py/venv/bin/pip3" install mocp-cli
    [[ -d "$PACKAGE_REPOS_DIR/mocp-cli" ]] && "$HOME/tools-py/venv/bin/pip3" install -e "$PACKAGE_REPOS_DIR/mocp-cli"

    if ! type mocp &>/dev/null; then
        if type apt-get &>/dev/null; then
            sudo apt-get install -y moc
        elif type brew &>/dev/null; then
            brew install moc
        fi
    fi
    source $HOME/commands.sh
}

if [[ -s "$HOME/tools-py/venv/bin/mocplayer" ]]; then
    mocplayer() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/mocplayer "$@"
    }
fi

jupyter-install() {
    [[ ! -d "$HOME/tools-py/venv" ]] && python3 -m venv "$HOME/tools-py/venv" && "$HOME/tools-py/venv/bin/pip3" install --upgrade pip wheel
    "$HOME/tools-py/venv/bin/pip3" install jupyter
    source $HOME/commands.sh
}

if [[ -s "$HOME/tools-py/venv/bin/jupyter" ]]; then
    jupyter() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/jupyter "$@"
    }
fi

grip-install() {
    [[ ! -d "$HOME/tools-py/venv" ]] && python3 -m venv "$HOME/tools-py/venv" && "$HOME/tools-py/venv/bin/pip3" install --upgrade pip wheel
    "$HOME/tools-py/venv/bin/pip3" install grip
    source $HOME/commands.sh
}

if [[ -s "$HOME/tools-py/venv/bin/grip" ]]; then
    grip() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/grip "$@"
    }
fi

if type grip &>/dev/null; then
    # Ex:
    #   grip-many
    #   grip-many . --depth 2
    #   grip-many . --hours 5
    grip-many() {
        [[ ! "$1" =~ ^-.* ]] && _dirname=$1 && shift
        [[ -z "$_dirname" ]] && _dirname="."

        if [[ ! -d "$_dirname" ]]; then
            echo "$_dirname is not a directory" >&2
            return 1
        fi

        echo "$_dirname" > GENERATED-README.md

        # Generate a markdown file containing links to all the found markdown files
        eval "findit $_dirname --complex \"\( -iname '*.md' -o -iname '*.idea' \) -print0 \" $@" |
        xargs -0 -I {} echo '- [{}]({})' |
        sort |
        grep -v 'GENERATED-README' >> GENERATED-README.md

        grip GENERATED-README.md "0.0.0.0:7777"
        rm GENERATED-README.md
    }
fi

rdb-install() {
    [[ ! -d "$HOME/tools-py/venv" ]] && python3 -m venv "$HOME/tools-py/venv" && "$HOME/tools-py/venv/bin/pip3" install --upgrade pip wheel
    "$HOME/tools-py/venv/bin/pip3" install rdbtools python-lzf
    source $HOME/commands.sh
}

if [[ -s "$HOME/tools-py/venv/bin/rdb" ]]; then
    rdb() {
        PYTHONPATH=$HOME $HOME/tools-py/venv/bin/rdb "$@"
    }

    redis-usage() {
        dump_path=$1
        system_redis=
        if [[ -z "$dump_path" ]]; then
            if [[ -d /var/lib/redis ]]; then
                dump_path="/var/lib/redis/dump.rdb"
                system_redis=yes
            elif [[ -d /usr/local/var/db/redis ]]; then
                dump_path="/usr/local/var/db/redis/dump.rdb"
                system_redis=yes
            fi
        fi

        if type redis-cli &>/dev/null && test -n "$system_redis"; then
            seconds_since_save=$(($(date +"%s") - $(redis-cli lastsave)))
            if [[ $seconds_since_save -gt 1000 ]]; then
                redis-cli bgsave >/dev/null
                echo "Running bgsave command since it was $seconds_since_save seconds since last save" >&2
                while [[ $seconds_since_save -gt 1000 ]]; do
                    sleep 1
                    seconds_since_save=$(($(date +"%s") - $(redis-cli lastsave)))
                done
                echo "Finished bgsave command" >&2
            fi
        fi


        if [[ $(uname) != "Darwin" && -n "$system_redis" ]]; then
            _pypath=$HOME
            _rdb_path=$HOME/tools-py/venv/bin/rdb
            PYTHONPATH=$_pypath sudo $_rdb_path -c memory "$dump_path" | sort -t, -k4 -h
        else
            rdb -c memory "$dump_path" | sort -t, -k4 -h
        fi
    }
fi

kubectl-install() {
    unset yn
    if type kubectl &>/dev/null; then
        kubectl_path=$(which kubectl)
        echo -e "kubectl found at $kubectl_path\n"
        kubectl version --client
        echo
        if [[ -n "$BASH_VERSION" ]]; then
            read -p "Replace this version? [y/n] " yn
        elif [[ -n "$ZSH_VERSION" ]]; then
            vared -p "Replace this version? [y/n] " -c yn
        fi
        [[ ! "$yn" =~ [yY].* ]] && return
    fi

    version="$1"
    [[ -n "$version" && ! "$version" =~ ^v ]] && version="v$version"
    [[ -z "$version" ]] && version=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

    echo "version -> $version"
    oldpwd=$(pwd)
    cd /tmp
    if [[ $(uname) == "Darwin" ]]; then
        curl -LO https://storage.googleapis.com/kubernetes-release/release/$version/bin/darwin/amd64/kubectl
    else
        curl -LO https://storage.googleapis.com/kubernetes-release/release/$version/bin/linux/amd64/kubectl
    fi
    if [[ -n "$(file kubectl | grep executable)" ]]; then
        chmod +x ./kubectl
        if [[ -n "$(groups | grep -E '(sudo|root|admin|wheel)')" ]]; then
            echo -e "$ sudo mv ./kubectl /usr/local/bin/kubectl"
            sudo mv -v ./kubectl /usr/local/bin/kubectl
            if [[ $? -ne 0 ]]; then
                mkdir -p "$HOME/bin"
                mv -v ./kubectl "$HOME/bin/kubectl"
            fi
        else
            mkdir -p "$HOME/bin"
            mv -v ./kubectl "$HOME/bin/kubectl"
        fi
    else
        # invalid version; details in the xml file downloaded
        cat ./kubectl
    fi
    cd "$oldpwd"
}

kind-install() {
    unset yn
    if type kind &>/dev/null; then
        kind_path=$(which kind)
        echo -e "kind found at $kind_path\n"
        kind --version
        echo
        if [[ -n "$BASH_VERSION" ]]; then
            read -p "Replace this version? [y/n] " yn
        elif [[ -n "$ZSH_VERSION" ]]; then
            vared -p "Replace this version? [y/n] " -c yn
        fi
        [[ ! "$yn" =~ [yY].* ]] && return
    fi

    oldpwd=$(pwd)
    cd /tmp
    if [[ $(uname) == "Darwin" ]]; then
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-darwin-amd64
    else
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-amd64
    fi
    chmod +x ./kind
    if [[ -n "$(groups | grep -E '(sudo|root|admin|wheel)')" ]]; then
        echo -e "$ sudo mv ./kind /usr/local/bin/kind"
        sudo mv -v ./kind /usr/local/bin/kind
        if [[ $? -ne 0 ]]; then
            mkdir -p "$HOME/bin"
            mv -v ./kind "$HOME/bin/kind"
        fi
    else
        mkdir -p "$HOME/bin"
        mv -v ./kind "$HOME/bin/kind"
    fi
    cd "$oldpwd"
}

terraform-install() {
    versions=(0.15.0 0.14.10 0.13.6 0.12.30 0.11.14)
    oldpwd=$(pwd)
    mkdir -p "$HOME/bin"
    cd /tmp
    for ver in "${versions[@]}"; do
        [[ -f "$HOME/bin/terraform_$ver" ]] && continue
        if [[ $(uname) == "Darwin" ]]; then
            wget https://releases.hashicorp.com/terraform/${ver}/terraform_${ver}_darwin_amd64.zip
            unzip terraform_${ver}_darwin_amd64.zip
        else
            wget https://releases.hashicorp.com/terraform/${ver}/terraform_${ver}_linux_amd64.zip
            unzip terraform_${ver}_linux_amd64.zip
        fi
        mv -v terraform "$HOME/bin/terraform_$ver"
    done
    cd "$HOME/bin"
    echo -e "\n\nWhich file should be linked to $HOME/bin/terraform"
    choices=($(ls -1 terraform_*))
    select choice in "${choices[@]}"; do
        break
    done
    if [[ -n "$choice" ]]; then
        rm terraform 2>/dev/null
        ln -s $choice terraform
    fi
    cd "$oldpwd"
}

circleci-install() {
    if [[ ! -f "/usr/local/bin/circleci" && ! -f "$HOME/bin/circleci" ]]; then
        curl https://raw.githubusercontent.com/CircleCI-Public/circleci-cli/master/install.sh --fail --silent | bash
        if [[ $? -ne 0 ]]; then
            echo "Failed to add circleci to /usr/local/bin... gonna try to add to ~/bin (since probably on linux)"
            mkdir -p "$HOME/bin"
            curl https://raw.githubusercontent.com/CircleCI-Public/circleci-cli/master/install.sh --fail --silent | DESTDIR="$HOME/bin" bash
        fi
        source $HOME/commands.sh
    fi
}

if type circleci &>/dev/null; then
    circleci-local-test() {
        JOB="$1"
        [[ -z "$JOB" ]] && JOB=test

        AWS_ACCESS_KEY_ID=$(grep aws_access_key_id ~/.aws/credentials 2>/dev/null | grep -Eo '\S+$')
        AWS_DEFAULT_REGION=$(grep region ~/.aws/config 2>/dev/null | grep -Eo '\S+$')
        AWS_SECRET_ACCESS_KEY=$(grep aws_secret_access_key ~/.aws/credentials 2>/dev/null | grep -Eo '\S+$')

        circleci config validate || return 1
        time circleci local execute --job $JOB \
            -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
            -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
            -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
            -e DOCKER_USER=$DOCKER_USER \
            -e DOCKER_PASSWORD=$DOCKER_PASSWORD
    }
fi

#################### acpi ####################

if type acpi &>/dev/null; then
    battery() {
        acpi -V | grep Battery
    }
fi

#################### aws ####################

if type aws &>/dev/null; then
    beanstalk-versions-by-app() {
        aws elasticbeanstalk describe-application-versions | grep ApplicationName | sort | uniq -c | sort -k1,1nr -k2
    }

    beanstalk-total-versions() {
        aws elasticbeanstalk describe-application-versions | grep ApplicationVersionArn | wc -l
    }

    aws-region-names() {
        aws ec2 describe-regions | grep RegionName | perl -pe 's/^.*: "(.*)",/$1/' | sort
    }

    aws-region-cycle() {
        [[ -z "$@" ]] && echo -e "\nNo aws command was specified" && return 1
        for region_name in $(aws-region-names | tr '\n' '\0' | xargs -0); do
            echo -e "\n\n%%%%%%%%%%%%%%%\n  $(echo $region_name | tr '[a-z]' '[A-Z]')\n%%%%%%%%%%%%%%%"
            aws --region $region_name "$@"
        done
    }
fi

#################### brew ####################

if type brew &>/dev/null; then
    brew-describe-installed() {
        brew list -1 | xargs brew desc 2>/dev/null
    }

    brew-reinstall-non-casks() {
        brew list -1 --formula | xargs brew reinstall
    }
fi

#################### cat ####################

cat-with-titles() {
    num_cols=$(($(tput cols) - 1))
    for fname in $(ls -1 $@); do
        echo -e "\n\n"
        draw-delimiter-line $num_cols
        echo -e "== [$fname] ==\n"
        cat "$fname"
    done
}

cat-with-titles-pound() {
    num_cols=$(($(tput cols) - 1))
    for fname in $(ls -1 $@); do
        echo -e "\n\n"
        draw-delimiter-line--pound $num_cols 2
        echo -e "## [$fname] ##\n"
        cat "$fname"
    done
}

cat-with-titles-html() {
    num_cols=$(($(tput cols) - 1))
    for fname in $(ls -1 $@); do
        echo -e "\n\n"
        draw-delimiter-line--html $num_cols "-" 2
        echo -e "<!-- [$fname] -->\n"
        cat "$fname"
    done
}

#################### compgen ####################

if type compgen &>/dev/null; then
    funcs-list() {
        compgen -A function | grep -v -E '(^_|nvm_)' | LL_COLLATE=c sort
    }

    funcs-list-all() {
        compgen -A function | LL_COLLATE=c sort
    }

    funcs-list-hidden() {
        compgen -A function | grep '^_' | LL_COLLATE=c sort
    }
elif type bash &>/dev/null; then
    funcs-list() {
        bash -c 'source ~/commands.sh && funcs-list'
    }

    funcs-list-all() {
        bash -c 'source ~/commands.sh && funcs-list-all'
    }

    funcs-list-hidden() {
        bash -c 'source ~/commands.sh && funcs-list-hidden'
    }
fi

funcs-that-do() {
    funcs-list | grep '\bdo\b' | tr '\n' ' ' && echo
}

funcs-that-install() {
    funcs-list | grep '\binstall\b' | tr '\n' ' ' && echo
}

#################### crontab ####################

crontab-active() {
    crontab -l | grep -vE '(^#|^$)'
}

#################### curl ####################

if type curl &>/dev/null; then
    weather-now() {
        location=$1
        # See https://github.com/chubin/wttr.in#one-line-output for output options
        curl "https://wttr.in/${location}?format='%c+%C+%t+%w+%p'"
    }

    weather-forecast() {
        location=$1
        curl "https://wttr.in/${location}"
    }

    news-help() {
        curl getnews.tech/:help
    }

    news-search() {
        query=$1
        [[ -z "$query" ]] && return 1
        curl -s "us.getnews.tech/${query},n=50,reverse"
    }

    news-cat-business() {
        curl -s "us.getnews.tech/category=business,n=50,reverse"
    }

    news-cat-entertainment() {
        curl -s "us.getnews.tech/category=entertainment,n=50,reverse"
    }

    news-cat-general() {
        curl -s "us.getnews.tech/category=general,n=50,reverse"
    }

    news-cat-health() {
        curl -s "us.getnews.tech/category=health,reverse,n=50,reverse"
    }

    news-cat-science() {
        curl -s "us.getnews.tech/category=science,n=50,reverse"
    }

    news-cat-sports() {
        curl -s "us.getnews.tech/category=sports,n=50,reverse"
    }

    news-cat-health() {
        curl -s "us.getnews.tech/category=health,n=50,reverse"
    }
fi

#################### date ####################

now() {
    date +'%a %I:%M:%S'
}

if type banner &>/dev/null; then
    if [[ $(uname) != "Darwin" ]]; then
        now-banner() {
            banner $(date +'%a %I:%M')
        }
    fi
fi

utcnow() {
    python -c 'from datetime import datetime; print(datetime.utcnow())' 2>/dev/null
    [[ $? -ne 0 ]] && python3 -c 'from datetime import datetime; print(datetime.utcnow())'

}

#################### df ####################

dfh() {
    if [[ $(uname) == "Darwin" ]]; then
        df -lPh
    else
        df -Th --total | grep -vE '(^none|^udev|^tmpfs|^cgmfs)'
    fi
}

#################### dig ####################

if type dig &>/dev/null; then
    dig-short() {
        dig $@ ANY +noall +answer
    }
fi

#################### docker ####################

# Only provide the docker-install shell func for Linux (not using Windows Subsystem
# for Linux), if user is part of an admin group (like sudo/root/wheel)
if [[ -z "$(echo $PATH | grep -E '(WINDOWS|Program Files)')" ]]; then
    if [[ -n "$(groups | grep -E '(sudo|root|wheel)')" ]]; then
        docker-install() {
            if [[ -f /usr/bin/apt-get ]]; then
                echo -e "\nInstalling/upgrading docker..."
                sudo apt-get install -y software-properties-common apt-transport-https ca-certificates
                if [[ -z "$(grep docker /etc/apt/sources.list)" ]]; then
                    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $codename stable"
                    sudo apt-get update
                fi
                sudo apt-get install -y docker-ce

            elif [[ -f /usr/bin/yum ]]; then
                echo -e "\nInstalling/upgrading docker..."
                sudo yum install -y yum-utils || return 1
                sudo yum-config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
                sudo yum install -y docker-ce || return 1
                sudo systemctl enable docker.service
                sudo systemctl enable containerd.service
            else
                echo -e "\nNot sure what to do with $(uname) yet"
                return 1
            fi
            sudo usermod -aG docker ${USER}
        }
    fi
fi

if type docker &>/dev/null; then
    docker-login() {
        if [[ -z "$DOCKER_USER" || -z "$DOCKER_PASSWORD" ]]; then
            echo "Please set DOCKER_USER and DOCKER_PASSWORD"
            return 1
        fi
        docker login -u $DOCKER_USER -p $DOCKER_PASSWORD
    }

    docker-get-auth-token() {
        echo "$DOCKER_USER:$DOCKER_PASSWORD" | /usr/bin/base64
    }

    docker-delete-all-images() {
        docker rmi $(docker images -q | sort -u) -f
        echo
        docker images
    }

    docker-delete-untagged-images() {
        docker rmi $(docker images | grep "<none>" | awk '{print $3}') -f
        echo
        docker images
    }

    docker-delete-unused-images() {
        docker image prune -af
        echo
        docker images
    }

    docker-stop-all-containers() {
        docker stop $(docker ps -qa | sort -u)
        echo
        docker ps -a
    }

    docker-delete-all-containers() {
        docker stop $(docker ps -qa | sort -u)
        docker rm $(docker ps -qa | sort -u)
        echo
        docker ps -a
    }

    docker-show-untagged-images() {
        docker images | grep -E '(<none>|REPOSITORY)'
    }

    docker-show-all-images() {
        docker images
    }

    docker-show-all-containers() {
        docker ps -a
    }

    docker-show-all-images-and-containers() {
        docker images
        echo
        docker ps -a
    }

    docker-show-all-containers-and-images() {
        docker ps -a
        echo
        docker images
    }

    docker-prune() {
        docker system prune --all --force --volumes
    }

    docker-ls () {
        echo -e "\nContainers:"
        docker container ls -a
        echo -e "\nImages:"
        docker image ls -a
        echo -e "\nVolumes:"
        docker volume ls
        echo -e "\nNetworks:"
        docker network ls
    }

    docker-destroy-all() {
        docker stop $(docker ps -qa | sort -u)
        docker system prune --all --force --volumes
        docker-ls
    }

    docker-top() {
        docker stats --all
    }

    docker-shell() {
        if [[ -z "$1" ]]; then
            echo "Container must be specified" >&2
            return 1
        fi
        if [[ -z $(docker ps -q | grep $1) ]]; then
            if [[ -z $(docker ps -qa | grep $1) ]]; then
                echo "Container $1 does not exist" >&2
                return 1
            fi
            docker start $1
            if [[ $? -ne 0 ]]; then
                echo "Failed to start container $1" >&2
                return 1
            else
                echo "Started container $1 and sleeping 1 second..."
                sleep 1
            fi
        fi
        docker exec -it $1 bash
    }
fi

#################### du ####################

duh() {
    args=($@)
    if [[ -z "$args" ]]; then
        if [[ -n "$ZSH_VERSION" ]]; then
            args=({.*,*})
        elif [[ -n "$BASH_VERSION" ]]; then
            args=(.[!.]* *)
        fi
    fi
    du -sch ${args[@]} | sort -h
}

#################### /etc ####################

etc-group() {
    grep -vE '(^#|^_|:$)' /etc/group
}

etc-passwd() {
    grep -vE '(^#|^_|nologin$|false$)' /etc/passwd
}

#################### feh ####################

if type feh &>/dev/null; then
    alias feh="feh -x --scale-down"
    alias fehf="feh -F --zoom max"

    if [[ -f "$HOME/wallpapers/select.sh" ]]; then
        wallpaper-select-mode() {
            echo "Select wallpaper mode"
            choices=(one random none)
            select choice in "${choices[@]}"; do
                echo "$choice" > $HOME/.selected_wallpaper_mode
                break
            done
        }

        wallpaper-select() {
            echo "one" > $HOME/.selected_wallpaper_mode
            "$HOME/wallpapers/select.sh"
        }
    fi

    if [[ -n "$DISPLAY" ]]; then
        if [[ -f $HOME/.selected_wallpaper_mode ]]; then
            wallpaper_mode=$(cat $HOME/.selected_wallpaper_mode)
        else
            echo "none" > $HOME/.selected_wallpaper_mode
            wallpaper_mode=none
        fi

        if [[ "$wallpaper_mode" = "random" ]]; then
            if [[ -d $HOME/wallpapers/landscape ]]; then
                feh --randomize --recursive --bg-fill $HOME/wallpapers/landscape 2>/dev/null
            fi
        elif [[ "$wallpaper_mode" = "one" ]]; then
            if [[ -f $HOME/.selected_wallpaper_file ]]; then
                selected_wallpaper=$(cat $HOME/.selected_wallpaper_file)
                if [[ ! -f "$selected_wallpaper" ]]; then
                    cd "$HOME/wallpapers"
                    ./download.sh
                    cd -
                fi
                feh --bg-fill $selected_wallpaper 2>/dev/null
            else
                "$HOME/wallpapers/select.sh"
            fi
        elif [[ "$wallpaper_mode" != "none" ]]; then
            echo -e "\nDo not understand this wallpaper_mode: $wallpaper_mode"
            rm $HOME/.selected_wallpaper_mode
        fi

        unset wallpaper_mode
    fi
fi

#################### ffmpeg ####################

if type ffmpeg &>/dev/null; then
    to_mp3() {
        fname="$1"
        [[ -z "$fname" ]] && echo "No filename specified" && return 1
        time ffmpeg -i "$fname" -b:a 320k -map a "${fname%.*}.mp3"
    }
fi

#################### findit ####################

_default_exclude_dirs="*.egg, *.egg-info, .Private, .Trash, .cache, .cinnamon, .config, .eggs, .git, .mypy_cache, .npm, .nvm, .pyenv, .pytest_cache, .thumbnails, EGG-INFO, Library, __pycache__, backup-*, build, dist, env, node_modules, opensource, venv, venv*"

findit-default-excludes() {
    findit "$@" --exclude_dirs "$_default_exclude_dirs"
}

swps() {
    findit-default-excludes "$@" --type f --exts "sw[pon]" --stamp 2>/dev/null | sort
}

swps-no-stamp() {
    findit-default-excludes --type f --exts "sw[pon]" 2>/dev/null | sort
}

swps-delete() {
    swps --pipesort "rm -v {}"
}

findit-py() {
    findit-default-excludes "$@" --type f --exts "py"
}

findit-py-no-tests() {
    findit "$@" --exclude_dirs "$_default_exclude_dirs, test*" --type f --exts "py"
}

findit-test-dirs() {
    findit-default-excludes "$@" --type d --ipattern "*test*" | sort
}

findit-node-modules() {
    _exclude=$(echo $_default_exclude_dirs | tr ' ' '\n' | grep -v node_modules | tr '\n' ' ')
    findit "$@" --exclude_dirs "$_exclude" --type d --pattern "node_modules"
}

delete-node-modules() {
    findit-node-modules "$@" --pipesort "rm -rf"
}

findit-js-backend() {
    findit "$@" --exclude_dirs "$_default_exclude_dirs, lib, static, ui, deploy, test, unitTests, apidoc" --type f --exts "js"
}

findit-tf() {
    findit-default-excludes "$@" --type f --exts "tf, tfstate, tfvars"
}

findit-docs() {
    findit-default-excludes "$@" --type f --exts "pdf, doc, odt, md, txt"
}

findit-annotated-pdfs() {
    findit-default-excludes "$@" --type f --pattern 'annotated*pdf' --stamp | sort
}

findit-pics() {
    findit-default-excludes "$@" --type f --exts "png, jpg, jpeg, gif"
}

findit-audio() {
    findit-default-excludes "$@" --type f --exts "mp3, flac, ogg, m4a, wav"
}

findit-vids() {
    findit-default-excludes "$@" --type f --exts "mp4, flv, mkv, ogv, mov, webm, avi"
}

if type feh &>/dev/null; then
    pics-view() {
        findit-pics "$@" --pipesort "feh -Fd" &
    }
fi

if type mocp &>/dev/null; then
    audio-play() {
        mocp -S &>/dev/null
        mocp -c && findit-audio "$@" --pipesort "mocp -a" && mocp -p
    }
fi

if type vlc &>/dev/null; then
    vids-play() {
        _vlc="vlc"
        [[ $(uname) == "Darwin" ]] && _vlc="/Applications/VLC.app/Contents/MacOS/VLC"
        findit-vids "$@" --pipesort "$_vlc --fullscreen" &
    }
fi

findit-logs() {
    findit-default-excludes "$@" --type f --exts "log" --complex "! -size 0"
}

findit-json-slow() {
    findit-default-excludes "$@" --type f --pipesort "file" | grep 'JSON data$' | perl -pe 's/^(.*):.*$/$1/'
}

grep-logs() {
    findit-logs . --pipesort "grep -Hn --color $@" 2>/dev/null
}

logs-empty() {
    findit-default-excludes "$@" --type f --exts "log" --complex "-empty"
}

logs-empty-delete() {
    findit-default-excludes "$@" --type f --exts "log" --complex "-empty -delete"
}

logs-wcl() {
    findit-logs "$@" --pipesort 'wc -l'
}

logs-info() {
    findit-logs "$@" --pipesort 'grep -Hn --color INFO'
}

logs-error() {
    findit-logs "$@" --pipesort 'grep -Hn --color ERROR'
}

logs-debug() {
    findit-logs "$@" --pipesort 'grep -Hn --color DEBUG'
}

show-mac-garbage() {
    _exclude=$(echo $_default_exclude_dirs | tr ' ' '\n' | grep -v .Trash | tr '\n' ' ')
    findit "$@" --exclude_dirs "$_exclude" --pattern '._*, .Trashes, .Trash, .Spotlight-V100, __MACOSX, .TemporaryItems, .fseventsd, .DS_Store'
}

delete-mac-garbage() {
    show-mac-garbage --pipe "rm -rfv"
}

#################### fontsize ####################

fontsize() {
    printf '\33]50;%s' "xft:Inconsolata:size=$1"
    export FONT_SIZE=$1
}

#################### git ####################

if type git &>/dev/null; then
    git-email-address() {
        unset path _email_line
        path=$(pwd)
        while [[ ! -d "$path/.git" && "$path" != "/" ]]; do
            path="$(dirname $path)"
        done
        [[ "$path" != "/" ]] && _email_line=$(grep email "$path/.git/config")
        [[ -z "$_email_line" ]] && _email_line=$(grep email ~/.gitconfig 2>/dev/null)
        [[ -n "$_email_line" ]] && echo $_email_line | perl -pe 's/^.*email\s*=\s*(.*?)$/$1/'
    }

    git-merge-in() {
        localbranch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [[ -z "$localbranch" ]]; then
            echo "Not currently in a git repo."
            return 1
        fi

        branch="${1:-master}"
        [[ ! "$branch" =~ origin.* ]] && branch="origin/$branch"

        stashstatus=$(git stash)
        if [[ "$stashstatus" = "No local changes to save" ]]; then
            echo " - Repository is clean.. going to pull from $localbranch, then merge $branch'"
            git pull --rebase
            git merge $branch
        else
            echo " - Dirty repo.. going to stash local changes, pull from $localbranch, merge $branch, then re-apply local changes"
            echo "$stashstatus"
            git pull --rebase
            git merge $branch
            git stash pop
        fi

        conflicts=$(git status -s | grep '^UU')
        if [[ -n "$conflicts" ]]; then
            echo -e "\n\nThere are some merge conflicts!!\n$conflicts"
            if [[ "$stashstatus" != "No local changes to save" ]]; then
                echo -e "\nAfter fixing merge conflicts, run 'git stash pop' to re-apply your changes"
            fi
        fi
    }

    git-stash-parts() {
        git stash push -p -m "(Interactively selected parts to stash)"
    }

    git-stash-all-with-comment() {
        comment="$1"
        if [[ -z "$comment" ]]; then
            if [[ -n "$BASH_VERSION" ]]; then
                read -p "Enter stash comment: " comment
            elif [[ -n "$ZSH_VERSION" ]]; then
                vared -p "Enter stash comment: " -c comment
            fi
        fi
        [[ -z "$comment" ]] && return 1
        git stash push -m "$comment"
    }

    git-update-submodules() {
        git submodule foreach --recursive git pull origin master
    }

    lazy-add-commit() {
        fname="$1"
        if [[ -n "$fname" && -s "$fname" ]]; then
            currently_staged=$(git diff --cached)
            if [[ -n "$currently_staged" ]]; then
                echo -e "\nThe staging area is not clean\n\n$currently_staged"
                return 1
            fi
            git add "$fname"
            git diff --cached
            git commit -m "Add $fname"
            git status
        fi
    }

    lazy-commit-from-added-files() {
        tracked_files=$(git status -s | grep -v '??')
        added_files=$(echo -e "$tracked_files" | grep '^A ' | cut -c 4-)
        other_staged=$(echo -e "$tracked_files" | grep '^[MDRC] ')
        unmerged_problems=$(echo -e "$tracked_files" | grep '^[AMDRCU][AMDRCU]')

        if [[ -n "$unmerged_problems" ]]; then
            echo -e "unmerged_problems:\n$unmerged_problems"
            return 1
        fi
        if [[ -z "$added_files" ]]; then
            echo "There are no new files added to the staging area"
            echo -e "\n\$ git status -s"
            git status -s
            return 1
        fi
        if [[ -n "$other_staged" ]]; then
            echo -e "Unstaging these files...\n$other_staged"
            echo -e "$other_staged" | cut -c 4- | tr '\n' '\0' | xargs -0 -n1 git restore --staged 2>/dev/null
            echo -e "\n\$ git status -s"
            git status -s
        fi
        added_files_one_line=$(echo -e "$added_files" | tr '\n' ' ')
        git commit -m "Add file(s) $added_files_one_line"
        git status
    }

    alias glog="git log --find-renames --no-merges --pretty=format:'%C(yellow)%h %C(reset)%s %C(red)%ad %C(blue)%an%C(reset)'"
    alias glog2="glog --date local --name-status"
    alias glog3="git log --find-renames --stat --reverse -p"
fi

#################### grep ####################

system-info() {
    prompt_char="\$"
    [[ -n "ZSH_VERSION" ]] && prompt_char="%"
    if [[ -f /etc/os-release ]]; then
        echo -e "$prompt_char cat /etc/os-release | grep ..."
        grep -E '(\bNAME\b|\bVERSION\b|ID_LIKE|SUPPORT_URL)' /etc/os-release    # | grep --color '^[A-Z_]*'
        echo
    fi
    echo -e "$prompt_char uptime\n$(uptime)\n"
    echo -e "$prompt_char date\n$(date)\n"
    echo -e "$prompt_char echo \$DISPLAY\n$(echo $DISPLAY)\n"
    echo -e "$prompt_char whoami\n$(whoami)\n"
    echo -e "$prompt_char hostname\n$(hostname)\n"
    if type ifconfig &>/dev/null; then
        echo -e "$prompt_char ifconfig | grep ... | awk '{print \$2}'"
        ifconfig | grep "inet addr" | grep -Ev ":(127|172)" | awk '{print $2}' | cut -c 6-
        ifconfig | grep "inet [12]" | grep -Ev "(127|172)" | awk '{print $2}'
        echo
    fi
    if type ip &>/dev/null; then
        echo -e "$prompt_char ip addr show | grep ... | awk '{print \$2}'"
        ip addr show | grep "inet " | grep -Ev " (127|172)" | awk '{print $2}'
        echo
    fi
    if type wget &>/dev/null; then
        echo -e "$prompt_char wget https://httpbin.org/ip -qO - | grep origin | perl -pe 's/^.*\"(.*)\".*\$/\$1/'"
        wget https://httpbin.org/ip -qO - | grep origin | perl -pe 's/^.*\"(.*)\".*$/$1/'
        echo
    fi
    if type ss &>/dev/null; then
        echo -e "$prompt_char ss | grep -vE '(/var/run|/run/systemd|^$|^u_str *ESTAB *0 *0 *\* [0-9]*)'"
        ss | grep -vE '(/var/run|/run/systemd|^$|^u_str *ESTAB *0 *0 *\* [0-9]*)'
        echo

    fi
    if [[ -n "$(groups | grep -E '(sudo|root|admin|wheel)')" ]]; then
        echo -e "$prompt_char sudo lsof -Pn -i4 | grep -E '(ESTABLISHED|LISTEN)'"
        sudo lsof -Pn -i4 | grep -E '(ESTABLISHED|LISTEN)'
        echo
        if type lshw &>/dev/null; then
            echo -e "$prompt_char sudo lshw -short"
            sudo lshw -short
            echo
            echo -e "$prompt_char helpme dfh\n$(helpme dfh)\n"
            echo -e "$prompt_char dfh\n$(dfh)\n"
        else
            echo -e "$prompt_char helpme dfh\n$(helpme dfh)\n"
            echo -e "$prompt_char dfh\n$(dfh)\n"
        fi
        if type getent &>/dev/null; then
            echo -e "$prompt_char getent group sudo"
            getent group sudo
            echo
            echo -e "$prompt_char getent group wheel"
            getent group wheel
            echo
        fi
        if [[ -s /etc/shadow ]]; then
            echo -e "$prompt_char sudo cat /etc/shadow | grep -vE '(^[^:]+:\*|^$)' | sort"
            sudo cat /etc/shadow | grep -vE '(^[^:]+:\*|^$)' | sort
            echo
        fi
    else
        echo -e "$prompt_char helpme dfh\n$(helpme dfh)\n"
        echo -e "$prompt_char dfh\n$(dfh)\n"
    fi
    if type tmux &>/dev/null; then echo -e "$prompt_char tmux ls 2>&1\n$(tmux ls 2>&1)\n"; fi
    if type free &>/dev/null; then echo -e "$prompt_char free -h\n$(free -h)\n"; fi
    echo -e "$prompt_char grep -vE '(^#|^_|:$)' /etc/group | sort"
    grep -vE '(^#|^_|:$)' /etc/group | sort
    echo -e "\n$prompt_char grep -vE '(^#|^_|nologin$|false$)' /etc/passwd | sort"
    grep -vE '(^#|^_|nologin$|false$)' /etc/passwd | sort
    echo
}

grep-history() {
    grep -Hn --color "$@" ~/.*history*
}

grep-history-exact() {
    pattern=$1
    [[ -z "$pattern" ]] && return 1
    shift
    grep-history "\b$pattern\b" "$@"
}

grep-history-comments() {
    grep-history "^#"
}

#################### grepit ####################

grepit() {
    [[ -z "$@" ]] && return 1
    grep -HnI --color -R --exclude=\*.{pyc,swp,min.js,svg,png,jpg,jpeg,ttf,pdf,doc,xlsx,otf,mp3} --exclude=tags --exclude=conversations\*.json --exclude-dir=\*.egg --exclude-dir=\*.egg-info --exclude-dir=.Private --exclude-dir=.Trash --exclude-dir=.cache --exclude-dir=.cinnamon --exclude-dir=.config --exclude-dir=.eggs --exclude-dir=.git --exclude-dir=.mypy_cache --exclude-dir=.npm --exclude-dir=.nvm --exclude-dir=.pyenv --exclude-dir=.pytest_cache --exclude-dir=.thumbnails --exclude-dir=EGG-INFO --exclude-dir=Library --exclude-dir=__pycache__ --exclude-dir=build --exclude-dir=dist --exclude-dir=env --exclude-dir=node_modules --exclude-dir=opensource --exclude-dir=venv --exclude-dir=venv\* "$@" \.
}

grepit-tabs() {
    grepit $'\t'
}

grepit-count() {
    grepit -c "$@" | grep -v '0$' | sort -t: -k2,2nr -k1,1
}

grepit-count-dirs () {
    grepit -c "$@" | grep -v '0$' | awk -F: '
    {
        split($1, a, "/")
        dir = a[1]
        for (i = 2; i <= length(a) - 1; i++) {
            dir = dir "/" a[i]
        }
        count[dir] += $2
    }
    END {
        for (dir in count) {
            print dir ":" count[dir]
        }
    }' | sort -t: -k2,2nr -k1,1
}

grepit-non-matching-files() {
    grepit -c "$@" | grep '0$' | sort
}

grepit-cut() {
    [[ -z "$@" ]] && return 1
    grepit "$@" | cut -c 1-350 | grep --color "$@"
}

grepit-todo() {
    grepit $@ -iE '(todo|to-do)'
}

grepit-py() {
    [[ -z "$@" ]] && return 1
    grep -HnI --color -R --include=\*.py --exclude-dir=venv --exclude-dir=env --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=build --exclude-dir=.cache --exclude-dir=.eggs --exclude-dir=\*.egg-info --exclude-dir=__pycache__ --exclude-dir=.pytest_cache "$@" \.
}

grepit-py-no-tests() {
    [[ -z "$@" ]] && return 1
    grep -HnI --color -R --include=\*.py --exclude-dir=venv --exclude-dir=env --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=build --exclude-dir=.cache --exclude-dir=.eggs --exclude-dir=\*.egg-info --exclude-dir=__pycache__ --exclude-dir=.pytest_cache --exclude-dir=test\* "$@" \.
}

grepit-py-imports() {
    grepit-py -E "(from.*import|import)"
}

grepit-py-imports-no-tests() {
    grepit-py-no-tests -E "(from.*import|import)"
}

grepit-md() {
    [[ -z "$@" ]] && return 1
    grep -HnI --color -R --include=\*.md --exclude-dir=venv --exclude-dir=env --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=build --exclude-dir=.cache --exclude-dir=.eggs --exclude-dir=\*.egg-info --exclude-dir=__pycache__ --exclude-dir=.pytest_cache "$@" \.
}

grepit-md-include-venv-and-node_modules() {
    [[ -z "$@" ]] && return 1
    grep -HnI --color -R --include=\*.md --exclude-dir=dist --exclude-dir=build --exclude-dir=.cache --exclude-dir=.eggs --exclude-dir=\*.egg-info --exclude-dir=__pycache__ --exclude-dir=.pytest_cache "$@" \.
}

grepit-no-docs() {
    grepit --exclude=\*.{txt,md,rst,log} --exclude-dir=\*.dist-info "$@"
}

grepit-no-docs-no-tests() {
    grepit --exclude=\*.{txt,md,rst,log} --exclude-dir=\*.dist-info --exclude-dir=test\* "$@"
}

grepit-exact() {
    pattern=$1
    [[ -z "$pattern" ]] && return 1
    shift
    grepit "\b$pattern\b" "$@"
}

grep-object-info() {
    object="$1"
    [[ -z "$object" ]] && return 1
    grepit-no-docs "\b$object\b" | grep -Eo "($object\(|$object(\.\w+)+\(?)" |
    sort | uniq -c | sort -k1,1nr -k2 | grep -Ev '.(js|py)$'
}

grep-object-info-no-tests() {
    object="$1"
    [[ -z "$object" ]] && return 1
    grepit-no-docs-no-tests "\b$object\b" | grep -Eo "($object\(|$object(\.\w+)+\(?)" |
    sort | uniq -c | sort -k1,1nr -k2 | grep -Ev '.(js|py)$'
}

#################### helpme ####################

commands-functions-aliases() {
    out="$HOME/commands-functions-aliases.txt"
    alias > "$out"
    typeset -f >> "$out"
    echo $PATH | tr ':' '\0' |
         xargs -0 -I {} bash -c 'echo -e "\n"; ls -lhdF {}/* 2>/dev/null' >> "$out"
    less -FX "$out"
}

helpme() {
    cmd=$1
    [[ -z "$cmd" ]] && cmd="helpme"

    outfile="/tmp/helpme-$cmd.txt"
    rm $outfile 2>/dev/null
    touch $outfile

    # Print some help text about how this function should be invoked
    if [[ "$cmd" == "helpme" ]]; then
        echo "Usage: helpme command" >> $outfile
        echo "Use 'k' and 'j' to scroll up and down" >> $outfile
        echo -e "Use 'q' to exit.\n\n" >> $outfile
    fi

    # The `command -v` output is the same for bash and zsh
    cv=$(command -v $cmd)

    if [[ ! $cv =~ \/.* ]]; then
        echo -e "'$cv' is a shell function or builtin\n" >> $outfile
        echo -e "\n--------------------" >> $outfile
        if [[ -n "$BASH_VERSION" ]]; then
            echo -e "type -a $cmd\n" >> $outfile
            type -a $cmd >> $outfile
        elif [[ -n "$ZSH_VERSION" ]]; then
            echo -e "which $cmd\n" >> $outfile
            which $cmd >> $outfile
        fi
    elif [[ $cv =~ $HOME ]]; then
        echo -e "'$cv' path is in $HOME\n" >> $outfile
        cat $cv >> $outfile
    elif [[ $cv =~ alias.* ]]; then
        cat $cv >> $outfile
    else
        echo -e "${cv}\nFor more info, try 'man $cmd'"
        return 0
    fi

    less -FX $outfile
}

#################### jq ####################

if type jq &>/dev/null; then
    jq-pretty-less() {
        jq --color-output --indent 4 '.' "$@" | less -r
    }
fi

#################### ls ####################

unalias f 2>/dev/null
f() {
    if [[ -z "$@" ]]; then
        ls -gothr "$@" | grep '^-'
    else
        ls -gothrd "$@" | grep '^-'
    fi
}
unalias fa 2>/dev/null
fa() {
    if [[ -z "$@" ]]; then
        ls -gothrA "$@" | grep '^-'
    else
        ls -gothrdA "$@" | grep '^-'
    fi
}
f5() {
    f "$@" | tail -n 5
}
fa5() {
    fa "$@" | tail -n 5
}
f10() {
    f "$@" | tail -n 10
}
fa10() {
    fa "$@" | tail -n 10
}

unalias d 2>/dev/null
d() {
    if [[ -z "$@" || "$1" == "$HOME" ]]; then
        ls -gothr "$@" | grep '^d'
    else
        ls -gothrd "$@" | grep '^d'
    fi
}
unalias da 2>/dev/null
da() {
    if [[ -z "$@" || "$1" == "$HOME" ]]; then
        ls -gothrA "$@" | grep '^d'
    else
        ls -gothrAd "$@" | grep '^d'
    fi
}
d5() {
    d "$@" | tail -n 5
}
da5() {
    da "$@" | tail -n 5
}
d10() {
    d "$@" | tail -n 10
}
da10() {
    da "$@" | tail -n 10
}

unalias l 2>/dev/null
l() {
    ls -gothr "$@" | grep '^l'
}
unalias la 2>/dev/null
la() {
    ls -gothrA "$@" | grep '^l'
}
l5() {
    l "$@" | tail -n 5
}
la5() {
    la "$@" | tail -n 5
}
l10() {
    l "$@" | tail -n 10
}
la10() {
    la "$@" | tail -n 10
}

#################### lsblk ####################

if type lsblk &>/dev/null; then
    partitions() {
        lsblk -s -o name,size,type,fstype,label,mountpoint | grep -vE '(^[^a-zA-Z]|iso9660|/snap)'
    }

    partitions-uuid() {
        lsblk -s -o name,size,type,fstype,uuid,label,mountpoint | grep -vE '(^[^a-zA-Z]|iso9660|/snap)'
    }

    partitions-by-size() {
        lsblk -s -o name,size,type,fstype,label,mountpoint | grep -vE '(^[^a-zA-Z]|iso9660|/snap)' | sort -k2 -hr
    }

    partitions-iso9960-only() {
        lsblk -o name,size,type,fstype,label,mountpoint | grep -E '(part *iso9660|NAME)'
    }

    partitions-snap-only() {
        lsblk -o name,size,type,fstype,label,mountpoint | grep -E '(/snap|NAME)'
    }

    lsblk-all-fields-json() {
        lsblk -OJ
    }
fi

#################### man ####################

man-f() {
    man -f "$@" 2> /dev/null
}

man-list() {
    ls /usr/share/man/man[1-8]/*
}

man-grep() {
    [[ -z "$1" ]] && echo "Call with the name of a man-able command" && return 1
    phrase="$2"
    num_lines=${3:-5}

    MANWIDTH=$(( $(tput cols) -6 )) man $1 |
        grep -n -B $num_lines -A $num_lines --color=always -i "$phrase" |
        less -rFX
}

#################### nmcli ####################

if type nmcli &>/dev/null; then
    nmcli-list-networks() {
        nmcli dev wifi list | cut -c 28-
    }

    nmcli-status() {
        nmcli dev status
    }

    nmcli-connect-to() {
        ssid="$1"
        [[ -z "$ssid" ]] && echo "No SSID specified" && return 1
        sudo nmcli --ask dev wifi connect "$ssid"
    }

    nmcli-reconnect-to() {
        ssid="$1"
        [[ -z "$ssid" ]] && echo "No SSID specified" && return 1
        nmcli con up "$ssid"
    }
fi

#################### pandoc ####################

if type pandoc &>/dev/null; then
    mdcat () {
        pandoc -t plain $@
    }

    mdless () {
        pandoc -t plain $@ | less -FX
    }

    if type lynx &>/dev/null; then
        mdview () {
            pandoc $@ | lynx -vikeys -stdin
        }
    fi

    to_rst() {
        fname="$1"
        [[ -z "$fname" ]] && echo "No filename specified" && return 1
        [[ ! "$fname" =~ .*[mM][dD] ]] && echo "Not a markdown file" && return 1
        pandoc --from=markdown --to=rst --output="${fname%.*}.rst" "$fname"
    }
fi

#################### printenv ####################

env-var-names() {
   printenv | grep -o '^[^=]*' | sort
}

#################### ps ####################

p() {
    if [[ $(uname) == "Darwin" ]]; then
        ps -eo user,pid,ppid,tty,%cpu,%mem,command | grep -vE '(^_|^root)'
    else
        ps -eo user,pid,ppid,tty,cmd:200 | grep -v ' \['
    fi
}

pa() {
    if [[ $(uname) == "Darwin" ]]; then
        ps -eo user,pid,ppid,tty,%cpu,%mem,command
    else
        ps -eo user,pid,ppid,tty,cmd:200
    fi
}

psome() {
    if [[ $(uname) == "Darwin" ]]; then
        p | grep -vE '(/Applications/.*\.app/|/Library/.*\.app/|/System/Library|/usr/libexec|/usr/sbin|com\.docker\.|docker serve|ssh-agent|sshd:|cloudphotod|SafeEjectGPUAgent|bash$|zsh$|fish$)'
    else
        p | grep -vE '(chromium|firefox|chrome| /usr/| /lib/| /sbin/| /bin/login|dbus-launch|nm-applet|cinnamon|blueberry|avahi-daemon|sd-pam|gpg-agent|dbus-broker|dbus-daemon|ibus-daemon|scdaemon|fusermount3|systemd-userwork|bpfilter_umh|wpa_supplicant|xinit /|ssh-agent|sshd:|/snap|update-notifier|nemo-desktop|lightdm|syndaemon|mintUpdate|mintreport-tray|csd-.*|bash$|zsh$|fish$|urxvt$)'
    fi
}

if [[ $(uname) == "Darwin" && -n "$grep_perl" ]]; then
    papps() {
        p | grep -oP '/(Applications|Library)/.*?\.app/' | sort | uniq -c | sort -k1,1nr -k2
    }
fi

if type pstree &>/dev/null; then
    pst() {
        if [[ $(uname) == "Darwin" ]]; then
            pstree -u $USER
        else
            pstree -np
        fi
    }
fi

#################### pumount ####################

if type pumount &>/dev/null; then
    pumount-these() {
        for name in "$@"; do
            echo -e "\n% pumount $name"
            pumount "$name"
        done
    }
fi

#################### pwd ####################

here() {
    basename $(pwd)
}

#################### recordmydesktop ####################

if type recordmydesktop &>/dev/null; then
    export RECORDMYDESKTOP_FPS=4

    screencast() {
        fname=$1
        if [[ -z "$fname" ]]; then
            fname="screencast--$(date +'%Y_%m%d-%a-%H%M%S').ogv"
        else
            fname="$fname--$(date +'%Y_%m%d-%a-%H%M%S').ogv"
        fi

        echo -e "\nctrl-alt-p to pause\nctrl-alt-s to stop\n"
        recordmydesktop --on-the-fly-encoding --no-frame --full-shots --follow-mouse --fps $RECORDMYDESKTOP_FPS -o $fname
    }

    screencast-not-on-the-fly() {
        fname=$1
        if [[ -z "$fname" ]]; then
            fname="screencast--$(date +'%Y_%m%d-%a-%H%M%S').ogv"
        else
            fname="$fname--$(date +'%Y_%m%d-%a-%H%M%S').ogv"
        fi

        echo -e "\nctrl-alt-p to pause\nctrl-alt-s to stop\n"
        recordmydesktop --no-frame --full-shots --follow-mouse --fps $RECORDMYDESKTOP_FPS -o $fname
    }
fi

#################### scrot ####################

if type scrot &>/dev/null; then
    screenshot() {
        scrot -s '%Y_%m%d--%H%M_%S--'$(hostname)'--$wx$h.png'
    }

    scrot-loop() {
        message="<ENTER> take screenshot (select area with mouse), <CTRL>+<C> to stop loop "
        while true; do
            if [[ -n "$BASH_VERSION" ]]; then
                read -p "$message" yn
            elif [[ -n "$ZSH_VERSION" ]]; then
                vared -p "$message" -c yn
            fi
            scrot -s '%Y_%m%d--%H%M_%S--'$(hostname)'--$wx$h.png'
        done
    }
fi

#################### ssh ####################

if [[ -d ~/.ssh ]]; then
    if type ssh-agent &>/dev/null; then
        sshlazy() {
            found=($(find "$HOME/.ssh" -type f \( -name '*.pub' -o -name '*.pem' -o -name '*.cer' -o -name 'config*' -o -name 'known_hosts*' -o -name 'authorized_keys*' \) -prune -o -type f -print | sort))
            unset filtered
            if [[ -n "$1" ]]; then
                for fnd in "${found[@]}"; do
                    filtered=$(echo $fnd | grep "/$1$")
                    [[ -n "$filtered" ]] && break
                done
                if [[ -z "$filtered" ]]; then
                    for fnd in "${found[@]}"; do
                        filtered=$(echo $fnd | grep "$1")
                        [[ -n "$filtered" ]] && break
                    done
                fi
            fi
            loaded=$(ssh-add -l 2>/dev/null | grep -v "agent has no identities" | awk '{print $3}' | sort)
            [[ -z $SSH_AUTH_SOCK && -z "$SSH_AGENT_PID" ]] && eval $(ssh-agent -s)
            echo -e "$loaded" >/tmp/loaded-$$.txt
            if [[ -n "$filtered" ]]; then
                echo -e "$filtered" >/tmp/filtered-$$.txt
            else
                for fnd in "${found[@]}"; do
                    echo "$fnd" >>/tmp/filtered-$$.txt
                done
            fi
            filtered_not_loaded=$(comm -13 /tmp/loaded-$$.txt /tmp/filtered-$$.txt)
            rm /tmp/loaded-$$.txt /tmp/filtered-$$.txt

            _display=$DISPLAY
            unset DISPLAY
            [[ -n "$filtered_not_loaded" ]] && echo "$filtered_not_loaded" | tr '\n' '\0' | xargs -0 -n1 ssh-add
            DISPLAY=$_display
        }

        sshlazy-select() {
            found=($(find "$HOME/.ssh" -type f \( -name '*.pub' -o -name '*.pem' -o -name '*.cer' -o -name 'config*' -o -name 'known_hosts*' -o -name 'authorized_keys*' \) -prune -o -type f -print | sort))
            select choice in "${found[@]}"; do
                break
            done
            [[ -n "$choice" ]] && sshlazy $(basename "$choice")
        }
    fi

    ssh-fix-permissions() {
        chmod 700 ~/.ssh
        find ~/.ssh -type f -print0 | xargs -0 chmod 600
    }
fi

#################### sudo ####################

if [[ -n "$(groups | grep -E '(sudo|root|admin|wheel)')" ]]; then
    lsof-ports-ipv4() {
        sudo lsof -Pn -i4
    }

    if [[ -s /etc/shadow ]]; then
        etc-shadow() {
            sudo cat /etc/shadow | grep -vE '(^[^:]+:\*|^$)'
        }
    fi

    # if type blkid &>/dev/null; then
    #     partitions-labels-and-uuids() {
    #         sudo blkid
    #     }
    # fi

    if type nmap &>/dev/null; then
        nmap-local-machines10() {
            sudo nmap -sS -p22,7777 10.0.0.0/24
        }

        nmap-local-machines192() {
            sudo nmap -sS -p22,7777 192.168.0.0/24
            sudo nmap -sS -p22,7777 192.168.1.0/24
        }
    fi

    if type lshw &>/dev/null; then
        hardware() {
            sudo lshw -short
        }
    fi

    if type getent &>/dev/null; then
        sudo-users() {
            getent group sudo
        }
    fi

    if [[ $(uname) != "Darwin" ]]; then
        alias shutdown="sudo shutdown -h +0"
        alias reboot="sudo reboot"
        alias hibernate="systemctl hibernate -i"

        newuser() {
            username=$1
            if [[ -z "$username" ]]; then
                echo "Expected a username as first argument" >&2
                return 1
            fi
            shell_path="$(which zsh 2>/dev/null)"
            [[ -z "$shell_path" ]] && shell_path="$(which bash)"

            # Create the user
            echo -e "\nsudo useradd -m -s $shell_path $username" >&2
            sudo useradd -m -s $shell_path $username || return 1

            # Set permissions for the user's home directory
            sudo chmod 700 /home/$username

            # Add the user to groups
            group_names="audio,video,plugdev,netdev"
            if [[ "$2" == "sudo" || "$3" == "sudo" ]]; then
                group_names="sudo,$group_names"
            elif [[ "$2" == "docker" || "$3" == "docker" ]]; then
                group_names="docker,$group_names"
            fi
            sudo usermod -aG $group_names $username

            # Add an empty zshrc file so zsh doesn't bug you on first login
            [[ "$shell_path" =~ .*zsh.* ]] && sudo touch /home/$username/.zshrc

            # Make empty ~/.ssh/authorized_keys file
            sudo mkdir /home/$username/.ssh
            sudo chmod 700 /home/$username/.ssh
            sudo touch /home/$username/.ssh/authorized_keys
            sudo chmod 600 /home/$username/.ssh/authorized_keys
            sudo chown -R $username:$username /home/$username

            # Set a password for the user
            echo -e "\nsudo passwd $username" >&2
            sudo passwd $username

            # Clone base repo
            if type git &>/dev/null; then
                echo -e "\n$ sudo su - $username -c 'git clone https://github.com/kenjyco/base ~/repos/base'"
                sudo su - $username -c 'git clone https://github.com/kenjyco/base ~/repos/base'
                echo -e "\n$ sudo su - $username -c 'cd ~/repos/base; source ./install.sh'"
                sudo su - $username -c 'cd ~/repos/base; source ./install.sh'
                echo -e "\n$ sudo su - $username -c 'ls -ltrhA ~'"
                sudo su - $username -c 'ls -ltrhA ~'
            fi
        }

        newusergit() {
            username=$1
            [[ -z "$username" ]] && username="git"
            sudo useradd -m -s $(which git-shell) $username || return 1
            sudo chmod 700 /home/$username
            sudo mkdir /home/$username/.ssh
            sudo chmod 700 /home/$username/.ssh
            sudo touch /home/$username/.ssh/authorized_keys
            sudo chmod 600 /home/$username/.ssh/authorized_keys
            sudo chown -R $username:$username /home/$username
            if type tree &>/dev/null; then
                sudo tree /home/$username
            fi
            echo -e "\nAdd the '$username' user to the AllowUsers line of '/etc/ssh/sshd_config'"
        }

        purgeuser() {
            username=$1
            [[ -z "$username" ]] && return 1

            # Find out if the user is sure
            if [[ -n "$BASH_VERSION" ]]; then
                read -p "are you sure? [y/n] " yn
            elif [[ -n "$ZSH_VERSION" ]]; then
                vared -p "are you sure? [y/n] " -c yn
            fi

            [[ ! "$yn" =~ [yY].* ]] && return 1

            # Actually remove the user and their home directory
            echo -e "\nsudo deluser --remove-home $username" >&2
            sudo deluser --remove-home $username

            echo -e "\nCurrent directories in /home"
            ls -ltr /home
        }
    fi

    if [[ -f /usr/bin/apt-get ]]; then
        uninstall-hard() {
            sudo apt-get purge --auto-remove -y
        }

        APT_SECURITY_ONLY="/etc/apt/sources.security.only.list"

        make-security-only-list() {
            sudo bash -c "shopt -s globstar; cat /etc/apt/**/*.list | grep ^deb | grep security | sort | uniq > $APT_SECURITY_ONLY"
        }

        do-security-upgrades() {
            [[ ! -s $APT_SECURITY_ONLY ]] && make-security-only-list
            [[ ! -s $APT_SECURITY_ONLY ]] && echo "$APT_SECURITY_ONLY is empty" && return 1
            sudo apt-get update
            apt-get -s dist-upgrade -o Dir::Etc::SourceList=$APT_SECURITY_ONLY -o Dir::Etc::SourceParts=/dev/null |
            grep '^Inst' |
            cut -d' ' -f2 |
            sudo xargs apt-get install -y -o Dir::Etc::SourceList=$APT_SECURITY_ONLY
        }
    fi

    if type ntpd &>/dev/null; then
        ntp-sync-now() {
            sudo service ntp stop && sudo ntpd -gq && sudo service ntp start
        }
    fi

    if type hostnamectl &>/dev/null; then
        set-hostname() {
            newhostname=$1
            if [[ -z "$newhostname" ]]; then
                echo "Expected the new hostname as first argument" >&2
                return 1
            fi
            sudo hostnamectl set-hostname $newhostname || return 1

            # Modify/append line of /etc/hosts to set `127.0.1.1 $newhostname`
            matched=$(grep 127.0.1.1 /etc/hosts)
            if [[ -z "$matched" ]]; then
                sudo sh -c "echo 127.0.1.1    $newhostname ${newhostname}.localdomain >> /etc/hosts"
            else
                sudo sh -c "sed -i \"/127.0.1.1/c\127.0.1.1    $newhostname ${newhostname}.localdomain\" /etc/hosts" 2>/dev/null
            fi

            echo -e "results of 'hostname' command:"
            hostname
            echo -e "\ncontents of '/etc/hostname' file:"
            cat /etc/hostname
            echo -e "\ngrep of '127.0.1.1' in '/etc/hosts' file:"
            grep 127.0.1.1 /etc/hosts
        }
    fi
fi

#################### tmux ####################

if type tmux &>/dev/null; then
    Tmux() {
        session_name="${1-0}"
        tmux -2 attach-session -t $session_name -d 2>/dev/null || tmux -2 new-session -s $session_name
    }

    Tmux-join() {
        tmux_sessions_full=$(tmux ls 2>/dev/null)
        if [[ -z "$tmux_sessions_full" ]]; then
            echo "No tmux sessions to join"
            return 1
        fi

        num_sessions=$(echo -e "$tmux_sessions_full" | wc -l)
        session_names=($(echo -e "$tmux_sessions_full" | perl -pe 's/^([^:]+):.*$/$1/'))

        if [[ -z "$1" ]]; then
            if [[ $num_sessions -eq 1 ]]; then
                session_name="${session_names[0]}"
            else
                echo -e "$tmux_sessions_full\n"
                select selection in "${session_names[@]}"; do
                    break
                done
            fi
        else
            session_name="$1"
        fi
        tmux -2 attach-session -t $session_name
    }
fi

#################### tree ####################

if type tree &>/dev/null; then
    t() {
        tree -F $@
    }

    td() {
        tree -Fd $@
    }
fi

#################### urxvt ####################

if type urxvt &>/dev/null; then
    windowsize() {
        size=$1
        title=$2
        [[ ! "$size" =~ [0-9]+ ]] && size=11
        urxvt -title "(size-$size) $title" -geometry 90x25 -fn "xft:Inconsolata:size=$size" -e zsh &
        [[ $? -eq 0 ]] && disown && exit
    }

    big-window() { windowsize 16; }

    newwin(){
        title=$1
        geom=$2
        cmd='urxvt'
        if [[ -z "$title" ]]; then
            cmd="${cmd} -title \"$(basename $(pwd)) .::. $(date +'%b-%d at %I:%M%p')\""
        else
            cmd="${cmd} -title \"$title .::. $(date +'%b-%d at %I:%M%p')\""
        fi
        if [[ -n "$geom" ]]; then
            cmd="${cmd} -geometry $geom"
        fi
        echo "$cmd"
        eval "$cmd" &
        [[ $? -eq 0 ]] && disown && exit
    }

    new-asciicast-win() {
        urxvt -title 'asciinema-optimized' -geometry 160x40 -e zsh &
        [[ $? -eq 0 ]] && disown && exit
    }
fi

#################### venv ####################

venv-site-packages() {
    [[ -d "$1" && (-d "$1/bin" || -d "$1/Scripts") ]] && env_name=$1
    [[ -z "$env_name" ]] && env_name="venv"
    [[ ! -d $env_name ]] && echo "Can't find '$env_name'" && return 1
    if [[ -d "$env_name/lib/python3.5/site-packages" ]]; then
        cd "$env_name/lib/python3.5/site-packages"
    elif [[ -d "$env_name/lib/python3.6/site-packages" ]]; then
        cd "$env_name/lib/python3.6/site-packages"
    elif [[ -d "$env_name/lib/python3.7/site-packages" ]]; then
        cd "$env_name/lib/python3.7/site-packages"
    elif [[ -d "$env_name/lib/python3.8/site-packages" ]]; then
        cd "$env_name/lib/python3.8/site-packages"
    elif [[ -d "$env_name/lib/python3.9/site-packages" ]]; then
        cd "$env_name/lib/python3.9/site-packages"
    elif [[ -d "$env_name/lib/python3.10/site-packages" ]]; then
        cd "$env_name/lib/python3.10/site-packages"
    elif [[ -d "$env_name/lib/python3.11/site-packages" ]]; then
        cd "$env_name/lib/python3.11/site-packages"
    elif [[ -d "$env_name/lib/python3.12/site-packages" ]]; then
        cd "$env_name/lib/python3.12/site-packages"
    elif [[ -d "$env_name/lib/python3.13/site-packages" ]]; then
        cd "$env_name/lib/python3.13/site-packages"
    elif [[ -d "$env_name/Lib/site-packages" ]]; then
        cd "$env_name/Lib/site-packages"
    fi
}

venv-quick() {
    unset _python
    if type python3 &>/dev/null; then
        _python="python3"
    elif type python &>/dev/null; then
        _python="python"
    fi
    $_python -m venv venv
    venv/bin/pip install --upgrade pip wheel
}

#################### vim ####################

if type vim &>/dev/null; then
    [[ -z "$EDITOR" || "$EDITOR" =~ .*nano$ ]] && export EDITOR=$(which vim)

    if [[ -d "$HOME/.plugin_install_dir/vundle/vim-dirdiff" ]]; then
        vimdiff-dirs() {
            if [[ $# -ne 2 ]]; then
                echo "Exactly 2 arguments are expected to vimdiff-dirs"
                return 1
            else
                if [[ -d "$1" && -d "$2" ]]; then
                    # Shell-escape each path
                    dir1=$(printf '%q' "$1"); shift
                    dir2=$(printf '%q' "$1"); shift
                else
                    echo "Both arguments MUST be directories"
                    return 1
                fi
            fi
            vim -c "DirDiff $dir1 $dir2"
        }
    fi

    vim-spell() {
        vim -c 'set spell' "$@"
    }
fi

#################### vlc ####################

if [[ -s "/Applications/VLC.app/Contents/MacOS/VLC" ]]; then
    alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
fi

if type vlc &>/dev/null; then
    vlcf() {
        vlc --fullscreen "$@" &>/dev/null &
    }
fi

#################### watch ####################

watchit() {
    watch -n 10 -t "$@"
}

if type acpi &>/dev/null; then
    watch-battery() {
        watchit -d acpi
    }
fi

if type lsblk &>/dev/null; then
    watch-partitions() {
        watchit "lsblk -s -o name,size,type,fstype,label,mountpoint | grep -vE '(^[^a-zA-Z]|iso9660)'"
    }
fi

#################### xrandr ####################

if type xrandr &>/dev/null; then
    xrandr-connected-displays() {
        xrandr -q | grep -e '\bconnected\b' | perl -pe 's/^([\S]+).* (\d+x\d+).*/$1:$2/'
    }

    xrandr-fix-monitors() {
        position=${1:-above}
        allowed=(above below left-of right-of same-as)
        ok=
        for pos in "${allowed[@]}"; do
            [[ "$pos" == "$position" ]] && ok=yes && break
        done
        [[ -z "$ok" ]] && echo "Must pass in one of (${allowed[@]}) not \"$position\"" && return

        cmds=()
        names=()
        cmd=
        IFS=$'\n'; for line in $(xrandr -q | grep -A 1 -e '\bconnected\b'); do
            word=$(echo "$line" | awk '{print $1}')
            if [[ "$word" =~ ^[A-Z] || "$word" =~ ^[a-z] ]]; then
                cmd="xrandr --output $word --mode "
                names+=($word)
            elif [[ "$word" =~ ^[0-9] ]]; then
                cmd+="$word "
                if [[ -z "${cmds[@]}" ]]; then
                    cmd+="--primary"
                else
                    cmd+="--$position ${names[-2]}"
                fi
                cmds+=($cmd)
            fi
        done; unset IFS
        echo -e "\nCurrent:\n$(xrandr-connected-displays)\n\nExecuting:"
        for cmd in "${cmds[@]}"; do
            echo " -> $cmd"
            eval "$cmd"
        done
    }
fi

#################### xscreensaver ####################

if type xscreensaver-command &>/dev/null; then
    screensaver-stop() {
        xscreensaver-command -exit
    }

    screensaver-start() {
        [[ -z $(pgrep xscreensaver) ]] && /usr/bin/xscreensaver -no-splash &
        xscreensaver-command -activate &
        disown
    }

    if [[ -f "$HOME/.dotfiles_path" && -d "$(cat $HOME/.dotfiles_path)/x/xscreensaver" ]]; then
        screensaver-select() {
            IFS=$'\n'; select saver in $(find $(cat ~/.dotfiles_path)/x/xscreensaver -type f); do
                cp -av "$saver" ~/.xscreensaver
                break
            done; unset IFS

            screensaver-stop &>/dev/null
            /usr/bin/xscreensaver -no-splash &>/dev/null &
            disown

            if [[ -n "$(echo $saver | grep -E '(carousel|images|slideshow)')" ]]; then
                echo -e "\n\nMake sure to set your image directory in xscreensaver-demo"
                echo " - Click the 'Advanced' tab"
                echo " - Check the 'Choose Random Image' box"
                echo " - Click the 'Browse' button and navigate to desired image directory"
            fi
        }
    fi

    lockscreen() {
        if [[ -z "$DISPLAY" ]]; then
            if [[ -n "$TMUX" ]]; then
                echo "Call 'lockscreen' again after tmux detaches..."
                sleep 2
                tmux detach-client
                return
            else
                vlock
            fi
        else
            [[ -z $(pgrep xscreensaver) ]] && /usr/bin/xscreensaver -no-splash &
            xscreensaver-command -lock &
            disown
        fi
    }
fi

#################### PATH ####################

paths() {
    echo $PATH | tr ':' '\n'
}

if [[ -d "$HOME/bin-base" && -z "$(echo $PATH | grep bin-base)" ]]; then
    PATH="$HOME/bin-base:$PATH"
fi

if [[ -z $(echo $PATH | grep $HOME/bin:) && -z $(echo $PATH | grep $HOME/bin$) ]]; then
    PATH="$HOME/bin:$PATH"
fi

_private_files=($(ls $HOME/private*\.sh 2>/dev/null))
if [[ -n "$_private_files" ]]; then
    for private in $HOME/private*\.sh; do
        source "$private"
    done
fi

if [[ -n "$BASE_INSTALL_INTERACTIVE_MODE" ]]; then
    [[ ! -f "$HOME/.selected_prompt_mode" ]] && prompt-select-mode
    [[ ! -f "$HOME/.selected_prompt_mode" ]] && echo "system-default" > "$HOME/.selected_prompt_mode"
else
    [[ ! -f "$HOME/.selected_prompt_mode" ]] && echo "system-default" > "$HOME/.selected_prompt_mode"
fi

prompt_mode=$(cat $HOME/.selected_prompt_mode)
if [[ -n "$SSH_CONNECTION" ]]; then
    prompt-terse
elif [[ "$prompt_mode" = "system-default" ]]; then
    prompt-system-default
elif [[ "$prompt_mode" = "verbose" ]]; then
    prompt-verbose
elif [[ "$prompt_mode" = "terse" ]]; then
    prompt-terse
elif [[ "$prompt_mode" = "minimal" ]]; then
    prompt-minimal
elif [[ "$prompt_mode" = "minimal-plus" ]]; then
    prompt-minimal-plus
else
    echo -e "\nDo not understand this prompt_mode: $prompt_mode"
    rm $HOME/.selected_prompt_mode
fi
unset prompt_mode
