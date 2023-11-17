# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Powerlevel10k from the ~/.config/zsh/powerlevel10k/ directory
if [[ -r ~/.config/zsh/powerlevel10k/powerlevel10k.zsh-theme ]]; then
  source ~/.config/zsh/powerlevel10k/powerlevel10k.zsh-theme
fi

#envrc
eval "$(direnv hook bash)"

#Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

#Ruby
eval "$(rbenv init - zsh)"

# fnm
export PATH=/home/$USER/.fnm:$PATH
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

#History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

#Aliases
alias ls="ls -laG"

alias g="git"
alias gpf="git push --force-with-lease"
alias ga="git add"
alias gc="git commit"
alias gform="git fetch origin main:main && git rebase -i main"
alias gl="git log"

#Plugins
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=4,underline"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=1,underline"

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

