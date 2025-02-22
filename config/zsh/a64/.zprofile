#################################################
#
#  Start-up Setting
#

export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8

export EDITOR=vim

eval "$(/opt/homebrew/bin/brew shellenv)"

#################################################
#
#  PATH setting
#

export XDG_CONFIG_HOME="${HOME}/.config"
export ZDOTDIR="${HOME}" # .zshrc や .zprofile が ~/.config/zsh から読み込まれるようになる
# export ZDOTDIR="${XDG_CONFIG_HOME}/zsh" # .zshrc や .zprofile が ~/.config/zsh から読み込まれるようになる

#  Default
export USR_LOCAL_HOME="/usr/local"
# for openssl
export OPENSSL="$(brew --prefix openssl)"
# for pyenv
export PYENV_ROOT="${HOME}/.anyenv/envs/pyenv"
# for poetry
export POETRY_ROOT="${HOME}/.poetry"
# for asdf - node plugins
export GAWK_ROOT="/opt/homebrew/opt/gawk"
# for starship
export STARSHIP_CONFIG="${HOME}/.config/starship/starship.toml"
# /usr/bin/python3 -- system Python
# $(brew --prefix) python -v -- Homebrew Python
# ${HOME}/.anyenv/envs/pyenv/shims/python3 -- pyenv Python

# for binuitls
export BINUTIL_ROOT="${HOMEBREW_PREFIX}/opt/binutils"

path=(
  "$OPENSSL/bin"(N-/)
  "$USR_LOCAL_HOME/bin"
  "$USR_LOCAL_HOME/sbin"
  "$PYENV_ROOT/bin"(N-/)
  "$POETRY_ROOT/bin"(N-/)
  "$GAWK_ROOT/libexec/gnubin"(N-/)
  "$BINUTIL_ROOT/bin"(N-/)
  "$path[@]"
)

# pathの重複排除: ユニーク属性を追加
typeset -U path cdpath fpath manpath

#################################################
#
#  ANYENV setting
#

# ---------------
# pyenv
# ---------------
eval "$(pyenv init --path)"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

eval "$(anyenv init -)"

#################################################
#
#  setting COLOR
#

if type vivid >/dev/null 2>&1; then
  # https://github.com/sharkdp/vivid
  export LS_COLORS="$(vivid generate jellybeans)"
fi

#################################################
#
#  Loading
#

#  .zshrcを読み込む
if [ -f "${ZDOTDIR}/.zshrc" ] ; then
  source "${ZDOTDIR}/.zshrc"
fi
#  .zaliasesを読み込み
if [ -f "${ZDOTDIR}/.zaliases" ] ; then
  source "${ZDOTDIR}/.zaliases"
fi

if [ $SHLVL = 1 ]; then
  tmux new-session -A -s local-session
fi
