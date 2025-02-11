#█▓▒░ clean home
# export ZDOTDIR="$HOME"/.config/zsh
export AWS_SHARED_CREDENTIALS_FILE="$HOME"/.aws/credentials
export AWS_CONFIG_FILE="$HOME"/.aws/config
export KUBECACHEDIR="$XDG_RUNTIME_DIR"/kube
export STARSHIP_CACHE="$XDG_CACHE_HOME"/starship
export TFENV="$XDG_DATA_HOME"/terraform

#█▓▒░ man
export MANPAGER='nvim --cmd ":lua vim.g.noplugins=1" +Man!'
export MANWIDTH=999

#█▓▒░ preferred text editor
export EDITOR=nvim
export VISUAL=nvim

#█▓▒░ fzf & clipboard menu
export CM_LAUNCHER="fzf"
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#ccd2d9,fg+:#d0d0d0,bg:#39274D,bg+:#39274D
  --color=hl:#875FAF,hl+:#87FF5F,info:#ab92fc,marker:#87FF5F
  --color=prompt:#87FF5F,spinner:#87FF5F,pointer:#87FF5F,header:#483160
  --color=gutter:#483160,border:#39274D,preview-fg:#e1d6f8,preview-bg:#201430
  --color=preview-border:#875FAF,preview-scrollbar:#875FAF,preview-label:#87FF5F,label:#8edf5f
  --color=query:#d9d9d9,disabled:#3f3d46
  --border="block" --border-label-pos="0" --preview-window="border-bold"
  --padding="0" --margin="1" --prompt="❯ " --marker="❯"
  --pointer="◈" --separator="~" --scrollbar="▌" --layout="reverse"'

#█▓▒░ language
export LC_COLLATE=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_MONETARY=en_US.UTF-8
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LESSCHARSET=utf-8

#█▓▒░ no mosh titles
export MOSH_TITLE_NOPREFIX=1

#█▓▒░ gpg cli in the tty
GPG_TTY=$(tty)
export GPG_TTY
