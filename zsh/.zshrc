# Editor
export EDITOR=nvim
export VISUAL=nvim

# XDG
export XDG_CONFIG_HOME="$HOME/.config"

# Homebrew
[[ "$OSTYPE" == "darwin"* ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

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

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Go
if [[ "$OSTYPE" == "darwin"* ]]; then
  go env -w GOPATH=/opt/homebrew/go
  GOPATH=/opt/homebrew/go
else
  go env -w GOPATH=/home/linuxbrew/.linuxbrew/go
  GOPATH=/home/linuxbrew/.linuxbrew/go
fi

go env -w GOBIN=$GOPATH/bin
GOBIN=$GOPATH/bin
PATH=$PATH:$GOBIN

#Aliases
alias ls="ls -laG"

alias g="git"
alias ga="git add"
alias gc="git commit"

alias bx="bundle exec"

alias vimp="rg --no-ignore --hidden -g '!.git/' --files | fzf-tmux -p -w 90% -h 80% --reverse --preview \"bat --color=always --line-range=:500 {}\" | xargs -o nvim"
alias rscope="rg -g 'spec/**/*_spec.rb' --files | fzf-tmux -p -w 90% -h 80% --reverse --preview \"bat --color=always --line-range=:500 {}\" | xargs -o bundle exec rspec"

# zsh Plugins
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="fg=4,underline"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND="fg=1,underline"

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# Prompt

function prompt_ruby_version {
  if [ -f .ruby-version ]; then
    RUBY_PROMPT=" %F{red} $(cat .ruby-version)%f"
  else 
    RUBY_PROMPT=""
  fi
}

function prompt_node_version {
  if [ -f .node-version ]; then
    NODE_PROMPT=" %F{green} $(cat .node-version)%f"
  else
    NODE_PROMPT=""
  fi
}

function update_prompt {
  VERSION_PROMPT="$RUBY_PROMPT $NODE_PROMPT"
  NEWLINE=$'\n'
  PROMPT="%F{cyan}%2~%f %F{yellow}${vcs_info_msg_0_}%f ${VERSION_PROMPT}${NEWLINE}${ARROW} "
}

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats "%F{yellow}%b%f(%u%c)"
zstyle ':vcs_info:*' actionformats "%F{yellow}%b%f(%u%c) %F{magenta}%a%f"
zstyle ':vcs_info:*' stagedstr "%F{green}+%f"
zstyle ':vcs_info:*' unstagedstr "%F{red}-%f"
precmd() { vcs_info }
precmd_functions+=( precmd_vcs_info)
precmd_functions+=( prompt_ruby_version)
precmd_functions+=( prompt_node_version)
precmd_functions+=( update_prompt)

function zle-line-init zle-keymap-select {
  local blueArrow="%F{blue}❯%f"
  local greenArrow="%F{green}❯%f"
  ARROW="${${KEYMAP/vicmd/${blueArrow}}/(main|viins)/${greenArrow}}"
  update_prompt
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select


setopt promptsubst
