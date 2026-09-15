# Editor
export EDITOR=nvim
export VISUAL=nvim

# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# Pi
export PI_CODING_AGENT_DIR="$XDG_CONFIG_HOME/pi/agent"
export PI_CODING_AGENT_SESSION_DIR="$XDG_DATA_HOME/pi/sessions"

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

alias n="nvim"
alias c="clear"
alias lg="lazygit"
alias oc="opencode --port"

alias j="jotix"
alias sgp="spotgo player"

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

source <(fzf --zsh)

ff() {
  if command -v bat &> /dev/null; then
    fzf --tmux center,90%,90% --preview 'bat --style=numbers --color=always {}'
  else
    fzf --tmux center,90%,90% --preview 'cat {}'
  fi
}

# fzf through my macos desktop apps like application viewer in mac by click one
# it will open the app, and you can also see the app size and other info in the
# preview window
# macOS only: relies on /Applications, mdls, stat, and open -a
if [[ "$OSTYPE" == "darwin"* ]]; then
  apps() {
    local app preview
    local -a dirs=(/Applications ~/Applications /System/Applications)

    preview='
      printf "\033[1;36m%s\033[0m\n\033[90m%s\033[0m\n\n" "$(basename {} .app)" {}
      printf "\033[1m%-9s\033[0m %s\n" "Size:" "$(du -sh {} 2>/dev/null | cut -f1)"
      printf "\033[1m%-9s\033[0m %s\n" "Modified:" "$(stat -f "%Sm" -t "%b %d, %Y %H:%M" {} 2>/dev/null)"
      printf "\033[1m%-9s\033[0m %s\n" "Version:" "$(mdls -raw -name kMDItemVersion {} 2>/dev/null)"
      printf "\033[1m%-9s\033[0m %s\n" "Bundle:" "$(mdls -raw -name kMDItemCFBundleIdentifier {} 2>/dev/null)"
      printf "\033[1m%-9s\033[0m %s\n" "Kind:" "$(mdls -raw -name kMDItemKind {} 2>/dev/null)"
    '

    app=$(find "${dirs[@]}" -maxdepth 2 -name '*.app' ! -name '.*' 2>/dev/null | sort | fzf \
      --tmux center,90%,80% \
      --prompt='Apps> ' \
      --delimiter / --with-nth=-1 \
      --header='ENTER open | CTRL-O reveal in Finder' \
      --preview="$preview" \
      --preview-window='right,55%,border-left' \
      --bind 'ctrl-o:execute(open -R {})')

    [[ -n "$app" ]] && open -a "$app"
  }
fi

export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden -g "!.git/"'
# alias vimp="fzf-tmux -p -w 90% -h 80% --reverse --preview \"bat --color=always --line-range=:500 {}\" | xargs -o nvim"
alias nff="ff | xargs -o nvim"
alias leetcode="nvim leetcode.nvim"
alias rscope="rg -g 'spec/**/*_spec.rb' --files | ff | xargs -o bundle exec rspec"


unalias sourceall 2>/dev/null || true
sourceall() {
    source ~/.config/zsh/.zshrc
    # Existing tmux servers keep the environment from when they started.
    tmux set-environment -g PATH "$PATH"
    tmux source-file ~/.config/tmux/tmux.conf
}

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

tsesh() {
    session=$(tmux ls | fzf --tmux | cut -d: -f1)
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

source "$XDG_CONFIG_HOME/zsh/prompt_versions.zsh"

function update_prompt {
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
precmd_functions+=( prompt_versions)
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
