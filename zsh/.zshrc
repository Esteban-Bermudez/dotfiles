# Editor
export EDITOR=nvim
export VISUAL=nvim

# XDG
export XDG_CONFIG_HOME="$HOME/.config"

# Homebrew
[[ "$OSTYPE" == "darwin"* ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

[[ "$OSTYPE" != "darwin"* ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# envrc
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# rbenv
if command -v rbenv &> /dev/null; then
    eval "$(rbenv init - zsh)"
fi

# pyenv
if command -v pyenv &> /dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init - zsh)"
fi

# fnm
if command -v fnm &> /dev/null; then
    export PATH=/home/$USER/.fnm:$PATH
    eval "$(fnm env --use-on-cd --version-file-strategy=recursive)"
fi

# zoxide
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init --cmd cd zsh)"
fi

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
alias ls="ls -lG"

alias g="git"
alias ga="git add"
alias gc="git commit"

alias bx="bundle exec"

dot() {
    if [ -n "$TMUX" ]; then
        tmux popup -E -h 80% -w 90% 'nvim ~/.config/'
    else
        nvim ~/.config/
    fi
}

alias vimp="rg --no-ignore --hidden -g '!.git/' --files | fzf-tmux -p -w 90% -h 80% --reverse --preview \"bat --color=always --line-range=:500 {}\" | xargs -o nvim"
alias rscope="rg -g 'spec/**/*_spec.rb' --files | fzf-tmux -p -w 90% -h 80% --reverse --preview \"bat --color=always --line-range=:500 {}\" | xargs -o bundle exec rspec"

alias c="clear"
alias lg="lazygit"
alias sourceall="source ~/.config/zsh/.zshrc && tmux source ~/.config/tmux/tmux.conf"

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
    NODE_PROMPT=" %F{green}󰎙 $(cat .node-version)%f"
  else
    NODE_PROMPT=""
  fi
}

function prompt_python_version_venv {
  if [ $VIRTUAL_ENV ]; then
    VENV_PROMPT=" %F{blue} $(python3 --version | sed 's/[Python ]*//g') (${VIRTUAL_ENV##*/})%f"
  else
    VENV_PROMPT=""
  fi
}

function update_prompt {
  VERSION_PROMPT="$RUBY_PROMPT$NODE_PROMPT$VENV_PROMPT"
  NEWLINE=$'\n'
  PROMPT="%F{cyan}%2~%f %F{yellow}${vcs_info_msg_0_}%f${VERSION_PROMPT}${NEWLINE}${ARROW} "
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
precmd_functions+=( prompt_python_version_venv)
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

# neofetch
if command -v neofetch &> /dev/null; then
  if [[ -z "$TMUX" ]]; then
    echo -e "\n" && neofetch
  fi
fi
