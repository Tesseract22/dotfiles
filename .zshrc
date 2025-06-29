bindkey -e
export KEYTIMEOUT=1
bindkey '^R' history-incremental-search-backward

autoload -Uz promptinit
autoload -Uz vcs_info
promptinit

function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd)      MODE="%F{red}[N]" ;;
    main|viins) MODE="%F{green}[I]" ;;
  esac
  zle reset-prompt
}

precmd() { vcs_info }
setopt histignorealldups sharehistory

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats '%b'
setopt PROMPT_SUBST
PROMPT='${MODE} %F{yellow}(${vcs_info_msg_0_}) %F{green}%~
%(?.%F{green}✓.%F{red}%?) %F{white}> '
zle -N zle-line-init
zle -N zle-keymap-select

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

alias ls='ls --color=auto'
alias sz='source ~/.zshrc'
alias ez='nvim ~/.zshrc'
alias et='nvim ~/.tmux.conf'

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

if [ -e ~/.envset.sh ] 
then 
    echo "sourcing env"
    source ~/.envset.sh
fi
