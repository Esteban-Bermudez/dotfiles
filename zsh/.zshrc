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

#Editor
export EDITOR=nvim
export VISUAL=nvim

#Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

[[ "$OSTYPE" != "darwin"* ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
#envrc
eval "$(direnv hook zsh)"

#Ruby
eval "$(rbenv init - zsh)"

# fnm
export PATH=/home/$USER/.fnm:$PATH
eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"

# zoxide
eval "$(zoxide init --cmd cd zsh)"

#History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

#Aliases
alias ls="ls -laG"

alias g="git"
alias ga="git add"
alias gc="git commit"

alias bx="bundle exec"

alias vim="nvim"
alias vi="nvim"

alias vimp="fd --type f --hidden --exclude .git | fzf-tmux -p -w 90% -h 80% --reverse --preview \"bat --color=always --line-range=:500 {}\" | xargs -o nvim"
alias rscope="rg -g 'spec/**/*_spec.rb' --files | fzf-tmux -p -w 90% -h 80% --reverse --preview \"bat --color=always --line-range=:500 {}\" | xargs -o rspec"


#Plugins
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=4,underline"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=1,underline"

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down


