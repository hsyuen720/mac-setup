sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Start Installation..."

echo "setup folder"
mkdir $HOME/projects
mkdir $HOME/playground

echo "setup homebrew"
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew update
brew upgrade

echo "setup command line tools"
brew install git
brew install python3
brew install mas

# NodeJS
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm install 16 --default # the minimum version expo-cli is 16
npm i -g yarn
yarn global add serve

# rvm
brew install gnupg
command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
command curl -sSL https://rvm.io/pkuczynski.asc | gpg --import -
\curl -sSL https://get.rvm.io | bash -s stable


# Mobile App Environment 
brew install watchman
brew install cocoapods
brew tap facebook/fb
brew install idb-companion
pip3 install fb-idb

# React Native Environment
yarn global add expo-cli
brew tap homebrew/cask-versions
brew install --cask zulu11 # OpenJDK distribution

# Flutter Environment
git clone https://github.com/flutter/flutter.git -b stable $HOME/flutter
echo "\n# Export Flutter Path" >> ~/.zshrc
echo "export PATH=\"\$PATH:$HOME/flutter/bin\"" >> ~/.zshrc

# Proxy Application
brew install mitmproxy

echo "setup terminal configuration"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
cp -a $(pwd)/fonts/* ~/Library/Fonts

echo "setup software"
brew install --cask visual-studio-code
brew install --cask postman
brew install --cask github
brew install --cask google-chrome
brew install --cask signal
brew install --cask appcleaner
brew install --cask notion
brew install --cask typora
brew install --cask android-studio
brew install --cask android-platform-tools
brew install --cask flipper
brew install --cask docker
brew install --cask anydesk

# ---------- Free App Store Application ---------- 
mas install 497799835 # Xcode
mas install 1295203466 # Microsoft Remote Desktop
mas install 409201541 # Pages
mas install 409203825 # Numbers
mas install 409183694 # Keynote
mas install 1176895641 # Spark
mas install 1444383602 # GoodNotes 5
mas install 1559269364 # Notion Web Clipper (Safari Web Extension)

# ---------- Paid App Store Application ---------- 
# Please comment this section when current apple account do not purchase these applications
mas install 1319778037 # iStat Menus
mas install 441258766 # Magnet

brew cleanup

echo "Done!"
