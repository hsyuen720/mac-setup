# Script of Setting up a new Mac Computer

This script is used to setup a new Mac Computer. It includes all applications/environment that I need.

## Prerequisite

-   Login Apple Account
-   Please comment the paid application session if the apple account has not purchased such applications.

## Usage

```sh
git clone https://github.com/hsyuen720/mac-setup.git
cd mac-setup
sh install.sh
```

## After installation

1. Modify `.zshrc` file and update the following varibale

    ```
    ZSH_THEME="powerlevel10k/powerlevel10k"
    
    plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
    ```

2. Import iStat Menu Setting (optional)

3. Setup flipper

    - Open Android Studio & retrieve Android SDK Version

4. Setup ohmyzsh `powerlevel10k` installation (kill and open terminal app)

    - type `p10k configure` if `powerlvel10k` setup does not prompt

5. Set terminal theme and change it to default (in `themes` folder).

6. Please add the following script into `~./zshrc` if nvm cannot add it to config file properly.

    ```
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    ```

