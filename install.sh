# Source this script with optional args "clean", "extras" and/or "gui"

# Create symbolic link to commands.sh
[[ -L "$HOME/commands.sh" ]] && rm "$HOME/commands.sh"
[[ -f ./commands.sh ]] && ln -s "$(pwd)/commands.sh" "$HOME/commands.sh"

# Set clean, extras, and gui vars
[[ "$1" == "clean" || "$2" == "clean" || "$3" == "clean" ]] && clean=clean
[[ "$1" == "extras" || "$2" == "extras" || "$3" == "extras" ]] && extras=yes
[[ "$1" == "gui" || "$2" == "gui" || "$3" == "gui" ]] && gui=yes

do_install() {
    if [[ -f /usr/bin/apt-get && -n "$(groups | grep sudo)" ]]; then
        echo -e "\nUpdating apt-get package listing"
        sudo apt-get update || return 1

        echo -e "\nInstalling/upgrading packages needed for pyenv..."
        sudo apt-get install -y make build-essential git wget curl llvm xz-utils libssl-dev zlib1g-dev libbz2-dev
        sudo apt-get install -y libreadline-dev libsqlite3-dev libncurses5-dev libncursesw5-dev libffi-dev liblzma-dev python-openssl

        if [[ -n "$extras" ]]; then
            echo -e "\nInstalling/upgrading other useful CLI packages..."
            sudo apt-get install -y vim zsh tmux htop pmount acpi dkms openssh-server colordiff tree ncdu ranger w3m w3m-img nmap mtr sqlite3 imagemagick
        fi

        echo -e "\nInstalling ntp..."
        sudo apt-get install -y ntp

        echo -e "\nRefreshing Ubuntu keys..."
        sudo apt-key adv --refresh-keys --keyserver keyserver.ubuntu.com

        echo -e "\nInstalling/upgrading docker and docker-compose..."
        sudo apt-get install -y software-properties-common apt-transport-https ca-certificates
        if [[ -z "$(grep docker /etc/apt/sources.list)" ]]; then
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
            sudo apt-get update
        fi
        sudo apt-get install -y docker-ce
        sudo usermod -aG docker ${USER}
        sudo su -c 'curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose'
        sudo chmod +x /usr/local/bin/docker-compose

        # echo -e "\nInstalling/upgrading yarn..."
        # if [[ -z "$(grep yarn -R /etc/apt/sources.list.d)" ]]; then
        #     curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
        #     echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
        #     sudo apt-get update
        # fi
        # sudo apt-get install -y yarn

        if [[ -n "$gui" ]]; then
            echo -e "\nInstalling Xorg and GUI packages"
            sudo apt-get install -y xserver-xorg-core xserver-xorg-video-intel xserver-xorg-input-kbd xserver-xorg-input-libinput
            sudo apt-get install -y xinit xclip xbindkeys awesome rxvt-unicode-256color feh scrot fonts-inconsolata
        fi
    elif [[ $(uname) == "Darwin" ]]; then
        if [[ ! -f /usr/local/bin/brew ]]; then
            echo -e "\nInstalling homebrew..."
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || return 1
        fi

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
        _brew_install_or_upgrade readline xz pyenv

        if [[ -n "$extras" ]]; then
            echo -e "\nInstalling/upgrading packages needed for tmux..."
            _brew_install_or_upgrade reattach-to-user-namespace tmux
        fi

        echo -e "\nInstalling/upgrading packages needed for modern bash..."
        _brew_install_or_upgrade bash bash-completion

        # echo -e "\nInstalling/upgrading packages needed for yarn..."
        # _brew_install_or_upgrade yarn

        if [[ -n "$extras" ]]; then
            echo -e "\nInstalling/upgrading other useful CLI packages ..."
            _brew_install_or_upgrade coreutils findutils wget colordiff tree ncdu ranger nmap mtr watch sqlite3
        fi

        if [[ -n "$gui" ]]; then
            if [[ ! -d /Applications/iTerm.app/ ]]; then
                echo -e "\nInstalling iterm2"
                brew cask install iterm2
            fi

            if [[ ! -d /Applications/VLC.app/ ]]; then
                echo -e "\nInstalling vlc"
                brew cask install vlc
            fi
        fi

        if [[ ! -d /Applications/Docker.app/ ]]; then
            echo -e "\nInstalling docker..."
            brew cask install docker
        fi

        if [[ -z $(grep "/usr/local/bin/bash" /etc/shells) ]]; then
            echo -e "\nAdding new version of bash to /etc/shells"
            sudo sh -c "echo '/usr/local/bin/bash' >> /etc/shells"
        fi
    fi
}

do_install
source "$HOME/commands.sh"
[[ "$clean" == "clean" ]] && get-completions clean
