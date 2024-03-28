sudo apt update
sudo apt upgrade

sudo apt install gnome-tweaks chrome-gnome-shell python3-pip wireshark ripgrep cmake curl python3-venv python3-pynvim python3-poetry unzip tmux git libgtop

poetry config virtualenvs.in-project true

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin

snap install brave nvim

# libnvidia-gl-535:i386

#download chrome https://www.google.com/chrome/next-steps.html?statcb=0&installdataindex=empty&defaultbrowser=0#
sudo apt install '/home/nick/Downloads/google-chrome-stable_current_amd64.deb' 

mkdir repos
cd repos
git config --global user.email "nmabe6212@gmail.com"
git config --global user.name "nmabe"
ssh-keygen -t rsa -b 4096 -C "nmabe6212@gmail.com"
ssh-add /home/nick/.ssh/github_id_rsa
cat /home/nick/.ssh/github_id_rsa.pub
ssh -T git@github.com
git clone https://github.com/winter5un/c-_template.git
git clone git@github.com:winter5un/weather_station.git
git clone git@github.com:winter5un/c-_template.git
mkdir godot
cd godot/
git clone https://github.com/winter5un/ThinManaLine.git
git clone https://github.com/winter5un/ThinManaLine.git
git clone git@github.com:winter5un/ThinManaLine.git
cd ..
git clone git@github.com:winter5un/vscode_python_template.git
git clone git@github.com:winter5un/codenotes.git
#nick ALL=(ALL) NOPASSWD: ALL
sudo visudo
poetry config --list

curl -# -L -o Hack.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
cd ~
sudo cp ~/Downloads/Hack/ fonts -r
