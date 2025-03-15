#
# yum install -y xclip xsel xorg-x11-xauth
# apt install -y xclip xsel
#
# Алиас для копирования содержимого файла в буфер обмена с использованием xclip
alias xs="function _copyfile() { cat \"\$1\" | xclip -selection clipboard; }; _copyfile"
# Алиас для копирования содержимого файла в буфер обмена с использованием xsel
#alias xs="function _copyfile() { cat \"\$1\" | xsel --clipboard --input; }; _copyfile"
