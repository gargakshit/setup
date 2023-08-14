#!/usr/bin/env zsh

install_homebrew() {
	echo "Installing homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	echo "Adding homebrew to PATH (temp)"
	eval "$(/opt/homebrew/bin/brew shellenv)"

	brew analytics off
	brew tap homebrew/cask-fonts
}

install_rosetta() {
	echo "Installing rosetta 2"
	softwareupdate --install-rosetta --agree-to-license
}

install_cli_applications() {
	APPLICATIONS="go pyenv tmux tree google-cloud-sdk ffmpeg neovim htop starship kubectl teleport"

	echo "Installing: $APPLICATIONS"
	brew install $(echo $APPLICATIONS)
}

install_nvm() {
	echo "Installing nvm"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash
}

install_omz() {
	echo "Installing oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

	echo "Installing zsh-autosuggestions"
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

install_gui_applications() {
	APPLICATIONS="google-chrome visual-studio-code spotify orbstack linear cron obsidian 1password slack slab 1password-cli raycast arc beeper jetbrains-toolbox rectangle git-credential-manager homebrew/cask/tailscale homebrew/cask/readdle-spark"

	echo "Installing GUI applications: $APPLICATIONS"
	brew install $(echo $APPLICATIONS)
}

install_fonts() {
	FONTS="font-jetbrains-mono font-iosevka"

	echo "Installing fonts: $FONTS"
	brew install $(echo $FONTS)
}

copy_configs() {
	echo "Decreasing key repeat delay"
	defaults write NSGlobalDomain InitialKeyRepeat -int 12
	defaults write NSGlobalDomain KeyRepeat -int 8

	echo "Defaulting to plaintext mode for textedit"
	defaults write com.apple.TextEdit RichText -int 0

	echo "Setting finder options"
	defaults write com.apple.finder ShowPathbar -bool true
	defaults write com.apple.finder ShowStatusBar -bool true
	defaults write com.apple.finder.plist ShowRecentTags 0
	chflags nohidden ~/Library

	echo "Enabling TID for sudo (requires password)"
	sudo sed -i ".bak" '2s/^/auth       sufficient     pam_tid.so\'$'\n/g' /etc/pam.d/sudo

	echo "Copying ssh config (will overwrite)"
	mkdir -p ~/.ssh/config
	cp .ssh/config ~/.ssh/config

	echo "Copying git config"
	cp .gitconfig ~/.gitconfig

	echo "Copying zshrc"
	cp .zshrc ~/.zshrc

	echo "Copying neovim config"
	mkdir -p ~/.config/nvim
	cp .config/nvim/init.vim ~/.config/nvim/init.vim

	echo "Copying ideavim config"
	cp .ideavimrc ~/.ideavimrc

	echo "Restarting system-ui server"
	killall SystemUIServer
}

make_dir_structure() {
	echo "Creating directory structure for work!"
	mkdir -pv ~/work/{akshit-deepsource,DeepSourceCorp}
}

cleanup() {
	echo "Performing cleanup"
	brew cleanup
}

all_set() {
	echo "You are all set!"
}

install_homebrew
install_rosetta
install_nvm
install_cli_applications
install_omz
install_fonts
install_gui_applications
copy_configs
make_dir_structure
cleanup
all_set
