sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Start Installation..."

# Helper functions
install() {
    local cmd=$1
    local install_cmd=$2
    if ! command -v "$cmd" &> /dev/null; then
        eval "$install_cmd"
    else
        echo "$cmd already installed, skipping..."
    fi
}

brew_install() {
    local package=$1
    local is_cask=${2:-false}
    
    if [ "$is_cask" = true ]; then
        if ! brew list --cask "$package" &> /dev/null 2>&1; then
            brew install --cask "$package"
        else
            echo "$package already installed, skipping..."
        fi
    else
        if ! brew list "$package" &> /dev/null 2>&1; then
            brew install "$package"
        else
            echo "$package already installed, skipping..."
        fi
    fi
}

mas_install() {
    local app_id=$1
    local app_name=$2
    if ! mas list | grep -q "$app_id"; then
        mas install "$app_id"
    else
        echo "$app_name already installed, skipping..."
    fi
}

echo "setup folder"
mkdir -p $HOME/projects $HOME/playground

echo "setup homebrew"
install "brew" "NONINTERACTIVE=1 /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
brew update && brew upgrade

echo "setup command line tools"
brew_install "git"
brew_install "python3"
brew_install "mas"

# NodeJS
if ! command -v nvm &> /dev/null && [ ! -s "$HOME/.nvm/nvm.sh" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    if ! grep -q "NVM_DIR" ~/.zshrc; then
        echo -e "\n# NVM Configuration" >> ~/.zshrc
        echo "export NVM_DIR=\"\$([ -z \"\${XDG_CONFIG_HOME-}\" ] && printf %s \"\${HOME}/.nvm\" || printf %s \"\${XDG_CONFIG_HOME}/nvm\")\"" >> ~/.zshrc
        echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\" # This loads nvm" >> ~/.zshrc
    fi
    nvm install 16 --default
else
    echo "NVM already installed, skipping..."
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

install "yarn" "npm i -g yarn"

# Development Tools
install "rvm" "brew install gnupg && curl -sSL https://rvm.io/mpapis.asc | gpg --import - && curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - && curl -sSL https://get.rvm.io | bash -s stable"
brew_install "watchman"
brew_install "cocoapods"
install "expo" "yarn global add expo-cli"
brew_install "zulu11" true

brew_install "mitmproxy"

echo "setup terminal configuration"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    echo "Oh My Zsh already installed, skipping plugins installation..."
fi

# Copy fonts if not exists
if [ ! -f "$HOME/Library/Fonts/MesloLGS NF Regular.ttf" ]; then
    cp -a $(pwd)/fonts/* ~/Library/Fonts
fi

# Configure terminal theme
if ! defaults read com.apple.Terminal "Window Settings" 2>/dev/null | grep -q "Monokai Pro (Filter Spectrum)"; then
    open "$(pwd)/themes/Monokai Pro (Filter Spectrum).terminal"
    sleep 3
    defaults write com.apple.Terminal "Default Window Settings" -string "Monokai Pro (Filter Spectrum)"
    defaults write com.apple.Terminal "Startup Window Settings" -string "Monokai Pro (Filter Spectrum)"
fi

# Configure .zshrc
if ! grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc; then
    sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
fi
if ! grep -q 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting)' ~/.zshrc; then
    sed -i '' 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
fi

echo "setup software"
# Development Tools
brew_install "visual-studio-code" true
brew_install "postman" true
brew_install "android-studio" true
brew_install "docker" true

# Browsers & Utilities
brew_install "google-chrome" true
brew_install "appcleaner" true
brew_install "typora" true
brew_install "finicky" true

# Android Tools
brew_install "android-platform-tools" true
if ! brew list | grep -q "idb-companion"; then
    brew tap facebook/fb && brew install idb-companion
fi

# App Store Applications
echo "setup app store applications"
mas_install "497799835" "Xcode"
mas_install "409201541" "Pages"
mas_install "409203825" "Numbers"
mas_install "409183694" "Keynote"
mas_install "1176895641" "Spark"

# Paid applications (comment out if not purchased)
mas_install "1319778037" "iStat Menus"
mas_install "441258766" "Magnet"

brew cleanup

echo "Done!"
