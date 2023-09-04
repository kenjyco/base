# Source this script with optional args: "clean" "extras" "gui" "all"
#    - all means "clean extras gui"

# Create symbolic link to commands.sh and bin/
[[ -L "$HOME/commands.sh" ]] && rm "$HOME/commands.sh"
[[ -L "$HOME/commands.fish" ]] && rm "$HOME/commands.fish"
[[ -L "$HOME/bin-base" ]] && rm "$HOME/bin-base"
[[ -f ./commands.sh ]] && ln -s "$(pwd)/commands.sh" "$HOME/commands.sh"
[[ -f ./commands.fish ]] && ln -s "$(pwd)/commands.fish" "$HOME/commands.fish"
[[ -d ./bin ]] && ln -s "$(pwd)/bin" "$HOME/bin-base"
[[ "$(basename $PWD)" == "base" ]] && echo "$PWD" > "$HOME/.base_path"

# Set clean, extras, and gui vars
unset clean extras gui all
[[ "$1" == "clean" || "$2" == "clean" || "$3" == "clean" ]] && clean=clean
[[ "$1" == "extras" || "$2" == "extras" || "$3" == "extras" ]] && extras=yes
[[ "$1" == "gui" || "$2" == "gui" || "$3" == "gui" ]] && gui=yes
[[ "$1" == "all" || "$2" == "all" || "$3" == "all" ]] && clean=clean && extras=yes && gui=yes && all=yes

# Determine if using Windows Subsystem for Linux
[[ -n "$(echo $PATH | grep -E '(WINDOWS|Program Files)')" ]] && wsl=yes

# Determine if its a cloud instance
[[ -d /var/lib/cloud/instance ]] && unset gui

do_install() {
    if [[ -f /usr/bin/apt-get ]]; then
        if [[ -z "$(groups | grep -E '(sudo|root)')" ]]; then
            echo -e "\nNot attempting to install/upgrade packages with apt-get..."
            return 1
        fi
        codename=$(lsb_release -cs)
        if [[ -s /etc/apt/sources.list.d/official-package-repositories.list ]]; then
            # This is a distro based on Ubuntu (like Linux Mint), so get codename of Ubuntu
            codename=$(grep archive.ubuntu.com/ubuntu /etc/apt/sources.list.d/official-package-repositories.list |
                awk '{print $3}' | grep -o '^[a-z]*' | uniq
            )
        fi

        echo -e "\nUpdating apt-get package listing"
        sudo apt-get update || return 1

        echo -e "\nInstalling/upgrading packages needed for pyenv..."
        sudo apt-get install -y make build-essential git wget curl llvm xz-utils libssl-dev zlib1g-dev libbz2-dev tk-dev
        sudo apt-get install -y libreadline-dev libsqlite3-dev libncurses5-dev libncursesw5-dev libffi-dev liblzma-dev
        sudo apt-get install -y python-openssl
        [[ $? -ne 0 ]] &&  sudo apt-get install -y python3-openssl

        if [[ -n "$extras" ]]; then
            echo -e "\nInstalling/upgrading other useful CLI packages..."
            sudo apt-get install -y vim zsh zsh-syntax-highlighting fish tmux htop glances jq pmount acpi dkms openssh-server colordiff tree ncdu ranger nnn w3m w3m-img nmap mtr tldr sqlite3 imagemagick pandoc lynx exuberant-ctags
            sudo apt-get install -y gtypist typespeed
        fi

        echo -e "\nInstalling ntp..."
        sudo apt-get install -y ntp

        echo -e "\nRefreshing Ubuntu keys..."
        sudo apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com

        if [[ -z "$wsl" ]]; then
            echo -e "\nInstalling/upgrading docker and docker-compose..."
            sudo apt-get install -y software-properties-common apt-transport-https ca-certificates
            if [[ -z "$(grep docker /etc/apt/sources.list)" ]]; then
                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $codename stable"
                sudo apt-get update
            fi
            sudo apt-get install -y docker-ce
            sudo usermod -aG docker ${USER}
            sudo su -c 'curl -L https://github.com/docker/compose/releases/download/1.29.1/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose'
            sudo chmod +x /usr/local/bin/docker-compose
        fi

        if [[ -n "$gui" ]]; then
            if [[ -z "$wsl" ]]; then
                echo -e "\nInstalling Xorg..."
                sudo apt-get install -y xserver-xorg-core xserver-xorg-video-intel xserver-xorg-input-kbd xserver-xorg-input-libinput xvfb
            fi
            echo -e "\nInstalling GUI packages..."
            sudo apt-get install -y xinit xclip xbindkeys awesome feh scrot fonts-inconsolata vlc
            sudo apt-get install -y rxvt-unicode-256color
            [[ $? -ne 0 ]] && sudo apt-get install -y rxvt-unicode
            sudo apt-get install -y recordmydesktop guvcview audacity inkscape gimp gifsicle ripperx lame
            sudo apt-get install -y gparted evince okular retext libreoffice
            sudo apt-get install -y emelfm2
        fi
    elif [[ -f /usr/bin/yum ]]; then
        if [[ -z "$(groups | grep -E '(sudo|root|wheel)')" ]]; then
            echo -e "\nNot attempting to install/upgrade packages with yum..."
            return 1
        fi
        echo -e "\nInstalling/upgrading packages needed for pyenv..."
        sudo yum install -y make tar patch gcc git wget curl llvm xz zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel

        echo -e "\nInstalling perl..."
        sudo yum install -y perl

        echo -e "\nInstalling/upgrading packages needed for modern bash..."
        sudo yum install -y bash-completion

        if [[ -n "$extras" ]]; then
            echo -e "\nInstalling/upgrading other useful CLI packages..."
            sudo yum install -y vim-enhanced zsh zsh-syntax-highlighting fish tmux htop glances jq pmount acpi dkms openssh-server colordiff tree ncdu ranger nnn w3m w3m-img nmap mtr tldr ImageMagick pandoc lynx ctags
            sudo yum install -y gtypist typespeed
            sudo yum install -y lshw lsof banner rsync
        fi

        echo -e "\nInstalling ntp..."
        sudo yum install -y ntp

        if [[ -z "$wsl" ]]; then
            echo -e "\nInstalling/upgrading docker and docker-compose..."
            sudo yum install -y yum-utils
            sudo yum-config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
            sudo yum install -y docker-ce docker-compose
            sudo usermod -aG docker ${USER}
            sudo systemctl enable docker.service
            sudo systemctl enable containerd.service
        fi
        if [[ -n "$gui" ]]; then
            if [[ -z "$wsl" ]]; then
                echo -e "\nInstalling Xorg..."
                sudo yum install -y xorg-x11-server-Xorg xorg-x11-server-common xorg-x11-drivers xorg-x11-drv-intel xorg-x11-font-utils xorg-x11-server-utils libinput xorg-x11-drv-libinput xorg-x11-server-Xdmx xorg-x11-server-Xvfb
            fi
            echo -e "\nInstalling GUI packages..."
                sudo yum install -y xorg-x11-xinit xclip xbindkeys awesome rxvt-unicode feh levien-inconsolata-fonts vlc
                sudo yum install -y rr wodim guvcview audacity inkscape gimp gifsicle lame
                sudo yum install -y gparted emelfm2 evince okular retext libreoffice
        fi
    elif [[ $(uname) == "Darwin" ]]; then
        if [[ ! -f /usr/local/bin/brew && ! -f /opt/homebrew/bin/brew ]]; then
            echo -e "\nInstalling homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || return 1
        elif [[ ! -w /usr/local/Cellar && ! -w /opt/homebrew/Cellar ]]; then
            echo -e "\nNot attempting to install/upgrade packages with brew..."
            return
        fi

        homebrew_base_path="/usr/local"
        [[ -d /opt/homebrew/bin ]] && export PATH="/opt/homebrew/bin:$PATH" && homebrew_base_path="/opt/homebrew"

        echo -e "\nGetting the list of packages already installed with brew..."
        _installed=$(brew list -1)
        _brew_install_or_upgrade() {
            for x in "$@"; do
                echo "checking $x"
                if [[ -z "$(echo -e "$_installed" | grep "$x")" ]]; then
                    brew install $x
                else
                    brew upgrade $x 2>/dev/null
                fi
            done
        }

        echo -e "\nUpdating brew..."
        brew update || return 1

        echo -e "\nInstalling/upgrading packages needed for pyenv..."
        _brew_install_or_upgrade readline xz zlib openssl sqlite3 pyenv

        if [[ -n "$extras" ]]; then
            echo -e "\nInstalling/upgrading packages needed for tmux..."
            _brew_install_or_upgrade reattach-to-user-namespace tmux
        fi

        echo -e "\nInstalling/upgrading packages needed for modern bash..."
        _brew_install_or_upgrade bash bash-completion

        if [[ -n "$extras" ]]; then
            echo -e "\nInstalling/upgrading other useful CLI packages ..."
            _brew_install_or_upgrade coreutils findutils grep wget watch vim zsh-syntax-highlighting fish htop glances pstree jq openssh colordiff tree ncdu ranger nnn w3m nmap mtr tldr sqlite3 imagemagick pandoc lynx ctags
            _brew_install_or_upgrade gtypist typespeed
        fi

        if [[ -n "$gui" ]]; then
            if [[ ! -d /Applications/iTerm.app/ ]]; then
                echo -e "\nInstalling iterm2"
                brew install iterm2
            fi

            if [[ ! -d /Applications/VLC.app/ ]]; then
                echo -e "\nInstalling vlc"
                brew install vlc
            fi
        fi

        if [[ -z $(grep "$homebrew_base_path/bin/bash" /etc/shells) ]]; then
            echo -e "\nAdding new version of bash to /etc/shells"
            sudo sh -c "echo '$homebrew_base_path/bin/bash' >> /etc/shells"
        fi
    elif [[ $(uname) =~ MINGW.* ]]; then
        echo -e "\nIt appears you are running MinGW (Minimalist GNU for Windows), likely"
        echo "via the Git Bash shell. Not going to do anything"
        echo -e "\nConsider enabling Windows Subsystem for Linux (WSL 2)"
        echo "  - https://docs.microsoft.com/en-us/windows/wsl/install-win10"
        echo "  - https://docs.microsoft.com/en-us/windows/wsl/install-manual"
        return 1
    else
        echo -e "\nNot sure what to do with $(uname) yet"
        return 1
    fi
}

do_install || return 1
parent_pid=$(ps -o ppid= $$)
if ps | grep "^$parent_pid" | grep 'fish$'; then
    # Parent PID is fish shell
    [[ -s "$HOME/commands.fish" ]] && echo -e "Install complete! Be sure to run the following...\n\n    source $HOME/commands.fish"
else
    # The install.sh was sourced by bash or zsh
    if [[ -s "$HOME/commands.sh" ]]; then
        source "$HOME/commands.sh"
    else
        return
    fi
    if [[ "$clean" == "clean" ]]; then
        get-completions clean
        [[ -n "$all" ]] && tools-py-install-all clean
    fi
fi

if type zsh &>/dev/null; then
    [[ ! -s "$HOME/.zshrc" ]] && touch "$HOME/.zshrc"
    if [[ -z "$(grep commands.sh $HOME/.zshrc)" ]]; then
        echo -e '\nif test -f "$HOME/commands.sh" && ! type dfh &>/dev/null; then source "$HOME/commands.sh"; fi' >> $HOME/.zshrc
    fi
fi
if type bash &>/dev/null; then
    [[ ! -s "$HOME/.bashrc" ]] && touch "$HOME/.bashrc"
    [[ ! -s "$HOME/.bash_profile" ]] && echo '[[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"' > $HOME/.bash_profile
    if [[ -z "$(grep commands.sh $HOME/.bashrc)" ]]; then
        echo -e '\nif test -f "$HOME/commands.sh" && ! type dfh &>/dev/null; then source "$HOME/commands.sh"; fi' >> $HOME/.bashrc
    fi
fi
if type fish &>/dev/null; then
    [[ ! -d "$HOME/.config/fish" ]] && mkdir -p "$HOME/.config/fish"
    [[ ! -s "$HOME/.config/fish/config.fish" ]] && touch "$HOME/.config/fish/config.fish"
    if [[ -z "$(grep commands.fish $HOME/.config/fish/config.fish)" ]]; then
        echo -e '\nif test -f "$HOME/commands.fish" && ! type dfh &>/dev/null; source "$HOME/commands.fish"; end' >> $HOME/.config/fish/config.fish
    fi
fi

if type vim &>/dev/null || type tmux &>/dev/null; then
    if [[ ! -s "$HOME/.vimrc" && ! -s "$HOME/.tmux.conf" && -f "$HOME/.base_path" ]]; then
        echo -e "\nCloning dotfiles repo since vim and/or tmux installed, but no local conf found"
        base_parent=$(dirname $(cat "$HOME/.base_path"))
        git clone https://github.com/kenjyco/dotfiles "$base_parent/dotfiles"
        "$base_parent/dotfiles/setup.bash"
    fi
fi
