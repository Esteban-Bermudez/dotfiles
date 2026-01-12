# Editor
export EDITOR=nvim
export VISUAL=nvim

# XDG
export XDG_CONFIG_HOME="$HOME/.config"

# Mise
eval "$($HOME/.local/bin/mise activate zsh)" # added by https://mise.run/zsh

# Homebrew
[[ "$OSTYPE" == "darwin"* ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# zoxide
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init --cmd cd zsh)"
fi

# History
HISTFILE=~/.zsh_history
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
HISTSIZE=100000
SAVEHIST=100000

#Aliases
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=3 --long --icons --git'
alias lta='lt -a'

alias g="git"
alias ga="git add"
alias gc="git commit"

alias bx="bundle exec"

alias d="docker"
alias n="nvim"
alias c="clear"
alias lg="lazygit"

cat() {
  if command -v bat &> /dev/null; then
    bat "$@"
  else
    command cat "$@"
  fi
}

dot() {
    if [ -n "$TMUX" ]; then
        tmux popup -E -h 80% -w 90% 'nvim ~/.config/'
    else
        nvim ~/.config/
    fi
}

ff() {
  if command -v bat &> /dev/null; then
    fzf-tmux -p -w 90% -h 90% --preview 'bat --style=numbers --color=always {}'
  else
    fzf-tmux -p -w 90% -h 90% --preview 'cat {}'
  fi
}

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden -g "!.git/"'
# alias vimp="fzf-tmux -p -w 90% -h 80% --reverse --preview \"bat --color=always --line-range=:500 {}\" | xargs -o nvim"
alias nff="ff | xargs -o nvim"
alias leetcode="nvim leetcode.nvim"
alias rscope="rg -g 'spec/**/*_spec.rb' --files | ff | xargs -o bundle exec rspec"


alias sourceall="source ~/.config/zsh/.zshrc && tmux source ~/.config/tmux/tmux.conf"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

tsesh() {
    session=$(tmux ls | fzf | cut -d: -f1)
    if [[ -z "$TMUX" ]]; then
        if [ -n "$session" ]; then
            tmux attach-session -t "$session"
        fi
    else
        if [ -n "$session" ]; then
            tmux switch -t "$session"
        fi
    fi
}

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
  elif [ -f .nvmrc ]; then
    NODE_PROMPT=" %F{green}󰎙 $(cat .nvmrc)%f"
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
if command -v fastfetch &> /dev/null; then
  if [[ -z "$TMUX" ]]; then
    echo -e "\n" && fastfetch
  fi
fi
