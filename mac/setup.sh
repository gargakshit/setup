#!/usr/bin/env zsh

install_homebrew() {
	echo "Installing homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	echo "Adding homebrew to PATH (temp)"
	eval "$(/opt/homebrew/bin/brew shellenv)"

	brew analytics off
	brew tap homebrew/cask-fonts

	echo "Installing homebrew dependencies"
	brew bundle -v
}

install_rosetta() {
	echo "Installing rosetta 2"
	softwareupdate --install-rosetta --agree-to-license
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

copy_configs() {
	echo "Decreasing key repeat delay"
	defaults write NSGlobalDomain InitialKeyRepeat -int 12
	defaults write NSGlobalDomain KeyRepeat -int 8
	defaults write -g ApplePressAndHoldEnabled 0

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

install_go_apps() {
	echo "Installing go apps"

	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
}

cleanup() {
	echo "Performing cleanup"
	brew cleanup
}

all_set() {
	echo "You are all set!"
}
