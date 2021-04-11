# Source this file

# Add aliases for ..
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

cdd() { mkdir -p "$1" && cd "$1" && pwd; }

if [[ -f "$HOME/.base_path" ]]; then
    base() {
        cd $(cat "$HOME/.base_path")
    }

    base-update() {
        oldpwd=$(pwd)
        base
        echo -e "\n\nU P D A T I N G   B A S E   R E P O"
        _swps=$(swps)
        if [[ -n "$_swps" ]]; then
            echo -e "\nThere are swp files found in 'base' dir, not updating"
            echo -e "\n$_swps"
            cd "$oldpwd"
            return 1
        fi
        commit_id_before=$(git reflog -1 | awk '{print $1}')
        repos-update
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
                    source ./install.sh
                fi
            fi
        fi
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
        _swps=$(swps)
        if [[ -n "$_swps" ]]; then
            echo -e "\nThere are swp files found in 'dotfiles' dir, not updating"
            echo -e "\n$_swps"
            cd "$oldpwd"
            return 1
        fi
        commit_id_before=$(git reflog -1 | awk '{print $1}')
        repos-update
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

if [[ $(uname) == "Darwin" ]]; then
    alias dfh="df -lPh"
    alias p="ps -eo user,pid,ppid,tty,%cpu,%mem,command | grep -vE '(^_|^root)' | less -FX"
    alias pa="ps -eo user,pid,ppid,tty,%cpu,%mem,command | less -FX"
    alias psome="p | grep -vE '(/Applications/.*\.app/|/Library/.*\.app/|/System/Library|/usr/libexec|/usr/sbin|com\.docker\.|ssh-agent|bash$|zsh$|fish$)' | less -FX"
    if [[ -n "$grep_perl" ]]; then
        alias papps="p | grep -oP '/(Applications|Library)/.*?\.app/' | sort | uniq -c | sort -k1,1nr -k2 | less -FX"
    fi
    if type pstree &>/dev/null; then
        alias pst="pstree -u $USER | less -FX"
    fi
else
    alias dfh="df -Th --total | grep -vE '(^none|^udev|^tmpfs|^cgmfs)'"
    alias p="ps -eo user,pid,ppid,tty,cmd:200 | grep -v ' \[' | less -FX"
    alias pa="ps -eo user,pid,ppid,tty,cmd:200 | less -FX"
    alias psome="p | grep -vE '(chromium|firefox| \/usr\/| \/lib\/| \/sbin\/|dbus-launch|nm-applet|cinnamon|blueberry|avahi-daemon|ssh-agent|sshd:|bash$|zsh$|fish$) | less -FX"
    alias pst="pstree -np | less -FX"
fi

#################### bash/zsh setup ####################

# Function to get name of current git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

if [[ -n "$BASH_VERSION" ]]; then
    # Enable tab-completion
    if [[ -f /etc/bash_completion ]]; then
        source /etc/bash_completion
    elif [[ -f /usr/local/etc/bash_completion ]]; then
        source /usr/local/etc/bash_completion
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
    shopt -s globstar

    # Set prompt
    PS1="[\h] \[\e[1;33m\]\[\e[1;33m\]\W\[\e[1;32m\]\$(parse_git_branch) \$\[\e[0m\] "

    # Add function to switch to a verbose prompt
    prompt-verbose() {
        PS1="\n\[\e[1;32m\]\u@\h:\[\e[0m\]\w\[\e[1;32m\]\$(parse_git_branch)\n\[\e[1;33m\]\$ \[\e[0m\]"
    }

    # Add function to switch to a terse prompt (default)
    prompt-terse() {
        PS1="[\h] \[\e[1;33m\]\[\e[1;33m\]\W\[\e[1;32m\]\$(parse_git_branch) \$\[\e[0m\] "
    }

    # Add function to switch to a minimal prompt
    prompt-minimal() {
        PS1="\n\$ "
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

    # Set prompt
    PROMPT="[%m] %{$fg_bold[yellow]%}%c%{$fg[green]%}\$(parse_git_branch) %# %{$reset_color%}"

    # Add function to switch to a verbose prompt
    prompt-verbose() {
        PROMPT="
%{$fg_bold[green]%}%n@%m:%{$fg[white]%}%~%{$fg[green]%}\$(parse_git_branch)
%{$fg[yellow]%}%# %{$reset_color%}"
    }

    # Add function to switch to a terse prompt (default)
    prompt-terse() {
         PROMPT="[%m] %{$fg_bold[yellow]%}%c%{$fg[green]%}\$(parse_git_branch) %# %{$reset_color%}"
    }

    # Add function to switch to a minimal prompt
    prompt-minimal() {
         PROMPT="
%# "
    }
fi

prompt-select-mode() {
    echo "Select prompt mode"
    choices=(verbose terse minimal)
    select choice in "${choices[@]}"; do
        echo "$choice" > $HOME/.selected_prompt_mode
        break
    done

    if [[ "$choice" = "verbose" ]]; then
        prompt-verbose
    elif [[ "$choice" = "terse" ]]; then
        prompt-terse
    elif [[ "$choice" = "minimal" ]]; then
        prompt-minimal
    fi
}

#################### completions ####################

bash_completion_dir="$(brew --prefix 2>/dev/null)/etc/bash_completion.d"
bash_completion_file="$(dirname $bash_completion_dir)/bash_completion"
if [[ $(uname) != "Darwin" && -z "$(groups | grep -E '(sudo|root)')" ]]; then
    bash_completion_dir="$HOME/.downloaded-completions"
    mkdir -p "$bash_completion_dir" 2>/dev/null
    bash_completion_file="$HOME/.bash_completion"
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

# Make sure bash/zsh (tab) completions are enabled for git, docker, & docker-compose
get-completions() {
    custom_fpath="$(_get_zsh_custom_fpath)"
    [[ -z "$custom_fpath" ]] && custom_fpath="$HOME/.zsh/completion"

    if [[ "$1" == "clean" ]]; then
        if [[ ! "$bash_completion_dir" =~ ${HOME}.* && ! "$bash_completion_dir" =~ \/root\/.* ]]; then
            if [[ -n "$(groups | grep -E '(sudo|root|admin)')" ]]; then
                echo -e "\nDeleting from $bash_completion_dir: docker, docker-compose, git-completion.bash"
                sudo rm -f $bash_completion_dir/docker $bash_completion_dir/docker-compose $bash_completion_dir/git-completion.bash 2>/dev/null
            fi
        else
            echo -e "\nDeleting from $bash_completion_dir: docker, docker-compose, git-completion.bash"
            rm -f $bash_completion_dir/docker $bash_completion_dir/docker-compose $bash_completion_dir/git-completion.bash 2>/dev/null
        fi

        echo -e "\nDeleting from $custom_fpath: _docker, _docker-compose, git-completion.zsh"
        rm -f "$custom_fpath/_docker" "$custom_fpath/_docker-compose" "$custom_fpath/git-completion.zsh" 2>/dev/null
    fi

    git_version=$(git --version 2>/dev/null | perl -pe 's/^git version (\S+).*$/$1/')
    docker_version=$(docker --version 2>/dev/null | perl -pe 's/^Docker version (\S+),.*/$1/')
    docker_compose_version=$(docker-compose --version 2>/dev/null | perl -pe 's/^docker-compose version (\S+),.*/$1/')
    zsh_urls=()
    bash_urls=()
    if [[ -n "$git_version" ]]; then
        zsh_urls+=(https://raw.githubusercontent.com/git/git/v$git_version/contrib/completion/git-completion.zsh)
        bash_urls+=(https://raw.githubusercontent.com/git/git/v$git_version/contrib/completion/git-completion.bash)
    fi
    if [[ -n "$docker_version" ]]; then
        zsh_urls+=(https://raw.githubusercontent.com/docker/cli/v$docker_version/contrib/completion/zsh/_docker)
        bash_urls+=(https://raw.githubusercontent.com/docker/cli/v$docker_version/contrib/completion/bash/docker)
    fi
    if [[ -n "$docker_compose_version" ]]; then
        zsh_urls+=(https://raw.githubusercontent.com/docker/compose/$docker_compose_version/contrib/completion/zsh/_docker-compose)
        bash_urls+=(https://raw.githubusercontent.com/docker/compose/$docker_compose_version/contrib/completion/bash/docker-compose)
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

custom_fpath="$(_get_zsh_custom_fpath)"
if [[ -n "$BASH_VERSION" ]]; then
    [[ ! -f $bash_completion_dir/git-completion.bash ]] && get-completions
    source "$bash_completion_file"
elif [[ -n "$ZSH_VERSION" ]]; then
    [[ ! -f "$custom_fpath/git-completion.zsh" ]] && get-completions
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

nvm-install() {
    if [[ "$1" == "clean" && -d ~/.nvm ]]; then
        echo -e "\nDeleting ~/.nvm and ~/.npm"
        rm -rf ~/.nvm ~/.npm 2>/dev/null
        unset NVM_DIR
    fi

    if [[ ! -d ~/.nvm ]]; then
        echo -e "\nInstalling nvm and latest 'long term support' version of node..."
        unset NVM_DIR
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        source "$NVM_DIR/nvm.sh"
        source "$NVM_DIR/bash_completion"
        nvm install --lts
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
    echo -e "\nInstalling Python 3.9.4..."
    pyenv install 3.9.4
}

# Prep pyenv (on linux)
if [[ $(uname) != "Darwin" && -d $HOME/.pyenv && -z "$PYENV_ROOT" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
fi

# Enable pyenv (on linux/mac)
if type pyenv &>/dev/null; then
    eval "$(pyenv init -)"

    pyenv-list-installable() {
        pyenv install --list | grep '^  [2-4]' | less -FX
    }

    pyenv-list-grep() {
        arg=${1-'^  [2-4]'}
        pyenv install --list | grep $arg | less -FX
    }

    pyenv-list-installable-all() {
        pyenv install --list | less -FX
    }

    pyenv-list-envs() {
        ls -d ~/.pyenv/versions/*/envs/*
    }

    pyenv-list-python-version-files() {
        findit --type f --pattern ".python-version"
    }
fi

#################### Tools ####################

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
        if [[ -n "$(groups | grep -E '(sudo|root|admin)')" ]]; then
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
    type kind &>/dev/null && return
    oldpwd=$(pwd)
    cd /tmp
    if [[ $(uname) == "Darwin" ]]; then
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.9.0/kind-darwin-amd64
    else
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.9.0/kind-linux-amd64
    fi
    chmod +x ./kind
    if [[ -n "$(groups | grep -E '(sudo|root|admin)')" ]]; then
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

#################### aws ####################

if type aws &>/dev/null; then
    beanstalk-versions-by-app() {
        aws elasticbeanstalk describe-application-versions | grep ApplicationName | sort | uniq -c | sort -k1,1nr -k2
    }

    beanstalk-total-versions() {
        aws elasticbeanstalk describe-application-versions | grep ApplicationVersionArn | wc -l
    }
fi

#################### compgen ####################

if type compgen &>/dev/null; then
    funcs-list() {
        compgen -A function | grep -v -E '(^_|nvm_)' | LL_COLLATE=c sort | less -FX
    }

    funcs-list-all() {
        compgen -A function | LL_COLLATE=c sort | less -FX
    }

    funcs-list-hidden() {
        compgen -A function | grep '^_' | LL_COLLATE=c sort | less -FX
    }
fi

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
fi

#################### dig ####################

if type dig &>/dev/null; then
    dig-short() {
        dig $@ ANY +noall +answer
    }
fi

#################### echo ####################

paths() {
    echo $PATH | tr ':' '\n'
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

#################### findit ####################

swps() {
    findit "$@" --pattern ".*sw[po]" --exclude_dirs "node_modules, venv, .git, opensource" --stamp 2>/dev/null | sort
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
        ifconfig | grep "inet addr" | egrep -v ":(127|172)" | awk '{print $2}' | cut -c 6-
        ifconfig | grep "inet [12]" | egrep -v "(127|172)" | awk '{print $2}'
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
    if [[ -n "$(groups | grep -E '(sudo|root|admin)')" ]]; then
        echo -e "$prompt_char sudo lsof -Pn -i4 | grep -E '(ESTABLISHED|LISTEN)'"
        sudo lsof -Pn -i4 | grep -E '(ESTABLISHED|LISTEN)'
        echo
        if type lshw &>/dev/null; then
            echo -e "$prompt_char sudo lshw -short"
            sudo lshw -short
            echo
            echo -e "$prompt_char alias dfh\n$(alias dfh)\n"
            echo -e "$prompt_char dfh\n$(dfh)\n"
        else
            echo -e "$prompt_char alias dfh\n$(alias dfh)\n"
            echo -e "$prompt_char dfh\n$(dfh)\n"
        fi
        if type getent &>/dev/null; then
            echo -e "$prompt_char getent group sudo"
            getent group sudo
            echo
        fi
        if [[ -s /etc/shadow ]]; then
            echo -e "$prompt_char sudo cat /etc/shadow | grep -vE '(^[^:]+:\*|^$)' | sort"
            sudo cat /etc/shadow | grep -vE '(^[^:]+:\*|^$)' | sort
            echo
        fi
    else
        echo -e "$prompt_char alias dfh\n$(alias dfh)\n"
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

#################### grepit ####################

grepit() {
    [[ -z "$@" ]] && return 1
    grep -HnI --color -R --exclude=\*.{pyc,swp,min.js,svg,png,jpg,jpeg,ttf,pdf,doc,xlsx,otf,mp3} --exclude-dir=.git --exclude-dir=venv --exclude-dir=env --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=build --exclude-dir=.cache --exclude-dir=.eggs --exclude-dir=\*.egg-info --exclude-dir=__pycache__ --exclude-dir=.pytest_cache "$@" \.
}

grepit-count() {
    grepit -c "$@" | grep -v '0$' | sort -k2,2nr -k1,1 -t ':' | less -FX
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
    grepit-no-docs "\b$object\b" | egrep -o "($object\(|$object(\.\w+)+\(?)" |
    sort | uniq -c | sort -k1,1nr -k2 | egrep -v '.(js|py)$'
}

grep-object-info-no-tests() {
    object="$1"
    [[ -z "$object" ]] && return 1
    grepit-no-docs-no-tests "\b$object\b" | egrep -o "($object\(|$object(\.\w+)+\(?)" |
    sort | uniq -c | sort -k1,1nr -k2 | egrep -v '.(js|py)$'
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

#################### ls ####################

unalias f 2>/dev/null
f() {
    if [[ -z "$@" ]]; then
        ls -gothr "$@" | grep '^-' | less -FX
    else
        ls -gothrd "$@" | grep '^-' | less -FX
    fi
}
unalias fa 2>/dev/null
fa() {
    if [[ -z "$@" ]]; then
        ls -gothrA "$@" | grep '^-' | less -FX
    else
        ls -gothrdA "$@" | grep '^-' | less -FX
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
        ls -gothr "$@" | grep '^d' | less -FX
    else
        ls -gothrd "$@" | grep '^d' | less -FX
    fi
}
unalias da 2>/dev/null
da() {
    if [[ -z "$@" || "$1" == "$HOME" ]]; then
        ls -gothrA "$@" | grep '^d' | less -FX
    else
        ls -gothrAd "$@" | grep '^d' | less -FX
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
    ls -gothr "$@" | grep '^l' | less -FX
}
unalias la 2>/dev/null
la() {
    ls -gothrA "$@" | grep '^l' | less -FX
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

#################### man ####################

man-f() {
    man -f "$@" 2> /dev/null
}

man-list() {
    ls /usr/share/man/man[1-8]/* | less -FX
}

#################### pandoc ####################

if type pandoc &>/dev/null; then
    mdless () {
        pandoc -t plain $@ | less -FX
    }

    if type lynx &>/dev/null; then
        mdview () {
            pandoc $@ | lynx -stdin
        }
    fi

    to_rst() {
        fname="$1"
        [[ -z "$fname" ]] && echo "No filename specified" && exit 1
        [[ ! "$fname" =~ .*[mM][dD] ]] && echo "Not a markdown file" && exit 1
        pandoc --from=markdown --to=rst --output="${fname%.*}.rst" "$fname"
    }
fi

#################### recordmydesktop ####################

if type recordmydesktop &>/dev/null; then
    screencast() {
        fname=$1
        if [[ -z "$fname" ]]; then
            fname="screencast--$(date +'%Y_%m%d-%a-%H%M%S').ogv"
        else
            fname="$fname--$(date +'%Y_%m%d-%a-%H%M%S').ogv"
        fi

        echo -e "\nctrl-alt-p to pause\nctrl-alt-s to stop\n"
        recordmydesktop --on-the-fly-encoding --no-frame --full-shots --follow-mouse --fps 4 -o $fname
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
            found=$(find "$HOME/.ssh" -type f \( -name '*.pub' -o -name '*.pem' -o -name 'config*' -o -name 'known_hosts*' -o -name 'authorized_keys*' \) -prune -o -type f -print | sort)
            if [[ -n "$1" ]]; then
                filtered=$(echo $found | grep "/$1$")
                [[ -z "$filtered" ]] && filtered=$(echo $found | grep $1)
            else
                filtered="$found"
            fi
            loaded=$(ssh-add -l 2>/dev/null | grep -v "agent has no identities" | awk '{print $3}' | sort)
            [[ -z $SSH_AUTH_SOCK && -z "$SSH_AGENT_PID" ]] && eval $(ssh-agent -s)
            echo -e "$loaded" >/tmp/loaded-$$.txt
            echo -e "$filtered" >/tmp/filtered-$$.txt
            filtered_not_loaded=$(comm -13 /tmp/loaded-$$.txt /tmp/filtered-$$.txt)
            rm /tmp/loaded-$$.txt /tmp/filtered-$$.txt

            _display=$DISPLAY
            unset DISPLAY
            [[ -n "$filtered_not_loaded" ]] && echo "$filtered_not_loaded" | tr '\n' '\0' | xargs -0 -n1 ssh-add
            DISPLAY=$_display
        }

        sshlazy-select() {
            found=($(find "$HOME/.ssh" -type f \( -name '*.pub' -o -name '*.pem' -o -name 'config*' -o -name 'known_hosts*' -o -name 'authorized_keys*' \) -prune -o -type f -print | sort))
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

if [[ -n "$(groups | grep -E '(sudo|root|admin)')" ]]; then
    alias lsof-ports-ipv4="sudo lsof -Pn -i4"

    if [[ -s /etc/shadow ]]; then
        etc-shadow() {
            sudo cat /etc/shadow | grep -vE '(^[^:]+:\*|^$)'
        }
    fi

    if type nmap &>/dev/null; then
        alias nmap-local-machines10="sudo nmap -sS -p22,7777 10.0.0.0/24"
        alias nmap-local-machines192="sudo nmap -sS -p22,7777 192.168.1.0/24"
    fi

    if type lshw &>/dev/null; then
        alias hardware="sudo lshw -short"
    fi

    if type getent &>/dev/null; then
        alias sudo-users="getent group sudo"
    fi

    if [[ $(uname) != "Darwin" ]]; then
        alias shutdown="sudo shutdown -h +0"
        alias reboot="sudo reboot"
        alias hibernate="systemctl hibernate"

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
        alias uninstall-hard="sudo apt-get purge --auto-remove -y"
        APT_SECURITY_ONLY="/etc/apt/sources.security.only.list"

        make-security-only-list() {
            sudo sh -c "grep ^deb /etc/apt/sources.list | grep security > $APT_SECURITY_ONLY"
        }

        do-security-upgrades() {
            [[ ! -f $APT_SECURITY_ONLY ]] && make-security-only-list
            sudo apt-get update
            apt-get -s dist-upgrade -o Dir::Etc::SourceList=$APT_SECURITY_ONLY -o Dir::Etc::SourceParts=/dev/null |
            grep '^Inst' |
            cut -d' ' -f2 |
            sudo xargs apt-get install -y -o Dir::Etc::SourceList=$APT_SECURITY_ONLY
        }
    fi

    if type ntp &>/dev/null; then
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
                sudo sh -c "echo 127.0.1.1    $newhostname >> /etc/hosts"
            else
                sudo sh -c "sed -i \"/127.0.1.1/c\127.0.1.1    $newhostname\" /etc/hosts" 2>/dev/null
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
fi

#################### venv ####################

venv-site-packages() {
    env_name=$1
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
    elif [[ -d "$env_name/Lib/site-packages" ]]; then
        cd "$env_name/Lib/site-packages"
    fi
}

#################### vim ####################

if type vim &>/dev/null; then
    [[ -z "$EDITOR" ]] && export EDITOR=$(which vim)
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

#################### PATH ####################

if [[ -d "$HOME/bin-base" && -z "$(echo $PATH | grep bin-base)" ]]; then
    PATH="$HOME/bin-base:$PATH"
fi

if [[ -z $(echo $PATH | grep $HOME/bin:) && -z $(echo $PATH | grep $HOME/bin$) ]]; then
    PATH="$HOME/bin:$PATH"
fi

[[ -s "$HOME/private.sh" ]] && source "$HOME/private.sh"
if [[ $(whoami) == "root" ]]; then
    prompt-verbose
else
    [[ ! -f "$HOME/.selected_prompt_mode" ]] && prompt-select-mode
    [[ ! -f "$HOME/.selected_prompt_mode" ]] && echo "terse" > "$HOME/.selected_prompt_mode"
    prompt_mode=$(cat $HOME/.selected_prompt_mode)
    if [[ "$prompt_mode" = "verbose" ]]; then
        prompt-verbose
    elif [[ "$prompt_mode" = "terse" ]]; then
        prompt-terse
    elif [[ "$prompt_mode" = "minimal" ]]; then
        prompt-minimal
    else
        echo -e "\nDo not understand this prompt_mode: $prompt_mode"
        rm $HOME/.selected_prompt_mode
    fi
    unset prompt_mode
fi
