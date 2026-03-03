alias pipes.sh='pipes.sh -c 5 -f 60'
alias tty-clock='tty-clock -c -C 5 -D'
alias sl="while true; do sl; done"
alias TokyoNight="$HOME/.config/hypr/scripts/themesscript/TokyoNight.sh"
fastfetch -c "$HOME/.config/fastfetch/config-compact.jsonc"
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

plugins=(
    git
    archlinux
    zsh-syntax-highlighting
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux

# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
#pokemon-colorscripts --no-title -s -r #without fastfetch
#config-compact --no-title -s -r | fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc --logo-type file-raw --logo-height 10 --logo-width 5 --logo -

# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH=$PATH:$HOME/.spicetify
export GEMINI_API_KEY="AIzaSyDPbHgHb65L9wEjh2cPiVc2cRvPbuFo_LQ"
export PATH=$PATH:"$HOME/.lmstudio/bin"
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
export PATH=$HOME/.local/bin:$PATH
alias winapps='~/.local/bin/winapps-src/bin/winapps'

export PATH=$PATH:/home/termixz/.spicetify
