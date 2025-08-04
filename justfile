all: nvim kitty helix installs

install PACKAGE:
	sudo dnf install {{PACKAGE}} --assumeyes 

enable-copr:
	sudo dnf copr enable atim/lazygit -y
	sudo dnf copr enable 

installs:
	sudo dnf copr enable atim/lazygit -y
	just install lazygit

	just install tldr
	just install helix
	just install neovim
	just install lsd
	just install btop
	just install ripgrep

	cargo install --git https://github.com/Myriad-Dreamin/tinymist --locked tinymist
	cargo install typstyle --locked
	cargo install --git https://github.com/typst/typst --locked typst-cli

configs-file: nvim kitty helix

nvim:
	ln -s ~/.config/nvim/init.lua ~/.config/config_paul/nvim/init.lua
	- echo "Linking neovim config. DONE."

kitty:
	ln -s --force ~/.config/config_paul/kitty  ~/.config/
	- echo "Linking kitty config. DONE."

nixos:
	- echo "todo nixos"

# this works
helix:
	# rm -f ~/.config/helix/config.toml
	ln -s --force ~/.config/config_paul/helix ~/.config/
	- echo "Linking helix config. DONE."
