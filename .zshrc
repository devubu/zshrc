# ~/.zshrc file for zsh interactive shells.
# see /usr/share/doc/zsh/examples/zshrc for examples

setopt autocd              # change directory just by typing its name
#setopt correct            # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

WORDCHARS=${WORDCHARS//\/} # Don't consider certain characters part of the word

# hide EOL sign ('%')
PROMPT_EOL_MARK=""

# configure key keybindings
bindkey -e                                        # emacs key bindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# enable completion features
autoload -Uz compinit
compinit -d ~/.cache/zcompdump
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History configurations
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=2000
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
#setopt share_history         # share command history data

# force zsh to show the complete history
alias history="history 0"

# configure `time` format
TIMEFMT=$'\nreal\t%E\nuser\t%U\nsys\t%S\ncpu\t%P'

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

configure_prompt() {
    prompt_symbol=㉿
    # Skull emoji for root terminal
    #[ "$EUID" -eq 0 ] && prompt_symbol=💀
    case "$PROMPT_ALTERNATIVE" in
        twoline)
            PROMPT=$'%F{%(#.blue.green)}┌──${debian_chroot:+($debian_chroot)─}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))─}(%B%F{%(#.red.blue)}%n'$prompt_symbol$'%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n└─%B%(#.%F{red}#.%F{blue}$)%b%F{reset} '
            # Right-side prompt with exit codes and background processes
            #RPROMPT=$'%(?.. %? %F{red}%B⨯%b%F{reset})%(1j. %j %F{yellow}%B⚙%b%F{reset}.)'
            ;;
        oneline)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{%(#.red.blue)}%n@%m%b%F{reset}:%B%F{%(#.blue.green)}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
        backtrack)
            PROMPT=$'${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%B%F{red}%n@%m%b%F{reset}:%B%F{blue}%~%b%F{reset}%(#.#.$) '
            RPROMPT=
            ;;
    esac
    unset prompt_symbol
}

# The following block is surrounded by two delimiters.
# These delimiters must not be modified. Thanks.
# START KALI CONFIG VARIABLES
PROMPT_ALTERNATIVE=twoline
NEWLINE_BEFORE_PROMPT=yes
# STOP KALI CONFIG VARIABLES

if [ "$color_prompt" = yes ]; then
    # override default virtualenv indicator in prompt
    VIRTUAL_ENV_DISABLE_PROMPT=1

    configure_prompt

    # enable syntax-highlighting
    if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
        ZSH_HIGHLIGHT_STYLES[default]=none
        ZSH_HIGHLIGHT_STYLES[unknown-token]=underline
        ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
        ZSH_HIGHLIGHT_STYLES[path]=bold
        ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
        ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[command-substitution]=none
        ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[process-substitution]=none
        ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
        ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
        ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
        ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[assign]=none
        ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
        ZSH_HIGHLIGHT_STYLES[named-fd]=none
        ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
        ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
        ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
        ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
        ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
    fi
else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%(#.#.$) '
fi
unset color_prompt force_color_prompt

toggle_oneline_prompt(){
    if [ "$PROMPT_ALTERNATIVE" = oneline ]; then
        PROMPT_ALTERNATIVE=twoline
    else
        PROMPT_ALTERNATIVE=oneline
    fi
    configure_prompt
    zle reset-prompt
}
zle -N toggle_oneline_prompt
bindkey ^P toggle_oneline_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|Eterm|aterm|kterm|gnome*|alacritty)
    TERM_TITLE=$'\e]0;${debian_chroot:+($debian_chroot)}${VIRTUAL_ENV:+($(basename $VIRTUAL_ENV))}%n@%m: %~\a'
    ;;
*)
    ;;
esac

precmd() {
    # Print the previously configured title
    print -Pnr -- "$TERM_TITLE"

    # Print a new line before the prompt, but only if it is not the first line
    if [ "$NEWLINE_BEFORE_PROMPT" = yes ]; then
        if [ -z "$_NEW_LINE_BEFORE_PROMPT" ]; then
            _NEW_LINE_BEFORE_PROMPT=1
        else
            print ""
        fi
    fi
}

# enable color support of ls, less and man, and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'

    export LESS_TERMCAP_mb=$'\E[1;31m'     # begin blink
    export LESS_TERMCAP_md=$'\E[1;36m'     # begin bold
    export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
    export LESS_TERMCAP_so=$'\E[01;33m'    # begin reverse video
    export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
    export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
    export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

    # Take advantage of $LS_COLORS for completion as well
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
    zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
fi

# Set up fzf key bindings and fuzzy completion
if [ -x /usr/bin/fzf ]; then
  source <(fzf --zsh)
fi

# custom functions
cdfzf() {
    if [ -n "$1" ]; then
        selected_dir="$(fd . "$1" -a -u -t d | fzf)"
    else
        selected_dir="$(fd -a -u -t d | fzf)"
    fi

    [ -n "$selected_dir" ] && cd "$selected_dir"
}

lsfzf() {
    if [ -n "$1" ]; then
        fd . "$1" -a -u | fzf --preview 'ls -la --color=always {}' --preview-window='~4,+{2}+4/3,<80(up),wrap'
    else
        fd -a -u | fzf --preview 'ls -la --color=always {}' --preview-window='~4,+{2}+4/3,<80(up),wrap'
    fi
}

llarfzf() {
    if [ -n "$1" ]; then
        fd . "$1" -a -u | fzf --preview 'ls -laR --color=always {}' --preview-window='~4,+{2}+4/3,<80(up),wrap'
    else
        fd -a -u | fzf --preview 'ls -laR --color=always {}' --preview-window='~4,+{2}+4/3,<80(up),wrap'
    fi
}

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# custom aliases
alias vim='nvim'
alias cbat='batcat --paging=never'
alias bfzf='fzf --preview="batcat --color=always {}"'
alias bfzfw='fzf --preview="batcat --color=always {}" --preview-window=wrap'
alias cfzf='fzf --preview="cat - --color=always {}"'
alias cfzfw='fzf --preview="cat - --color=always {}" --preview-window=wrap'
alias vfzf='nvim "$(fzf -m --preview="batcat --color=always {}")"'
alias vfzfs='nvim $(fzf --preview="batcat --color=always {}")'
alias gfzf='~/Tools/Custom/Bash/search/gfzf.sh'
alias gvfzf='~/Tools/Custom/Bash/search/gvfzf.sh'
alias claer='clear'
alias celar='clear'
alias clera='clear'
alias caler='clear'
alias clare='clear'
alias caelr='clear'
alias cealr='clear'
alias celra='clear'
alias cls='clear'
alias sl='ls'
alias lla='ls -la'
alias llar='ls -laR'
alias copy='xclip -sel clip'
alias paste='xclip -o -sel clip'
alias gensymbol='~/Tools/Custom/Bash/symbols_and_characters/symbol_generator.sh'
alias ath='~/Tools/Custom/Bash/symbols_and_characters/ascii_to_hexadecimal.sh'
alias atb64='~/Tools/Custom/Bash/symbols_and_characters/ascii_encoded_base64.sh'
alias b64ta='~/Tools/Custom/Bash/symbols_and_characters/base64_to_ascii.sh'
alias lowercase='~/Tools/Custom/Bash/symbols_and_characters/lowercase.sh'
alias uppercase='~/Tools/Custom/Bash/symbols_and_characters/uppercase.sh'
alias underscore='~/Tools/Custom/Bash/symbols_and_characters/underscore.sh'
alias and='~/Tools/Custom/Bash/symbols_and_characters/and.sh'
alias append='~/Tools/Custom/Bash/symbols_and_characters/append.sh'
alias prepend='~/Tools/Custom/Bash/symbols_and_characters/prepend.sh'
alias sansi='~/Tools/Custom/Bash/symbols_and_characters/strip_ansi.sh'
alias b64='~/Tools/Custom/Bash/file_encoders/b64.sh'
alias rb64='~/Tools/Custom/Bash/file_encoders/rb64.sh'
alias dwallpaper='~/Tools/Custom/Bash/set_wallpaper/dwallpaper.sh'
alias rwallpaper='~/Tools/Custom/Bash/set_wallpaper/rwallpaper.sh'
alias opacity='~/Tools/Custom/Bash/config_editor/alacritty/opacity/opacity.sh'
alias catall='find "$(pwd)" -type f | sort | xargs -I {} sh -c '\''echo "File: {}" && cat "{}" && echo'\'''
alias catcurrent='for file in *; do [ -f "$file" ] && echo "File: $(readlink -f "$file")" && cat "$file" && echo; done'
alias sudoautorecon='sudo /home/kali/.local/bin/autorecon'
alias vr='vim results.txt'
alias downloads='cd ~/Downloads'
alias tools='cd ~/Tools'
alias eh='~/Tools/Custom/Bash/info/eh.sh'
alias ep='~/Tools/Custom/Bash/info/ep.sh'
alias idocker0='~/Tools/Custom/Bash/info/idocker0.sh'
alias iens3='~/Tools/Custom/Bash/info/iens3.sh'
alias ieth0='~/Tools/Custom/Bash/info/ieth0.sh'
alias ilo='~/Tools/Custom/Bash/info/ilo.sh'
alias itun0='~/Tools/Custom/Bash/info/itun0.sh'
alias iwlan0='~/Tools/Custom/Bash/info/iwlan0.sh'
alias cw='~/Tools/Custom/Bash/symbols_and_characters/clear_whitespace.sh'
alias cel='~/Tools/Custom/Bash/symbols_and_characters/clear_emptylines.sh'
alias hlist='~/Tools/Custom/Bash/symbols_and_characters/horizontal_list.sh'
alias vlist='~/Tools/Custom/Bash/symbols_and_characters/vertical_list.sh'
alias sortips='~/Tools/Custom/Bash/symbols_and_characters/sortips.sh'
alias displayips='~/Tools/Custom/Bash/symbols_and_characters/displayips.sh'
alias revshells="~/Tools/Custom/Bash/web/revshells.sh"
alias cyberchef="~/Tools/Custom/Bash/web/cyberchef.sh"
alias gtfobins="~/Tools/Custom/Bash/web/gtfobins.sh"
alias lolbas="~/Tools/Custom/Bash/web/lolbas.sh"
alias hacktricks="~/Tools/Custom/Bash/web/hacktricks.sh"
alias hacktricks-cloud="~/Tools/Custom/Bash/web/hacktricks-cloud.sh"
alias payloadsallthethings-web="~/Tools/Custom/Bash/web/payloadsallthethings-web.sh"
alias internalallthethings-web="~/Tools/Custom/Bash/web/internalallthethings-web.sh"
alias wadscom="~/Tools/Custom/Bash/web/wadcoms.sh"
alias virustotal="~/Tools/Custom/Bash/web/virustotal.sh"
alias diffchecker="~/Tools/Custom/Bash/web/diffchecker.sh"
alias diagrams="~/Tools/Custom/Bash/web/diagrams.sh"
alias comment="~/Tools/Custom/Bash/symbols_and_characters/comment.sh"
alias gennote="~/Tools/Custom/Bash/note_generator/gennote.sh"
alias snmap="~/Tools/Custom/Bash/note_generator/snmap.sh"
alias mtmux="~/Tools/Custom/Bash/tmux_sessions/mtmux.sh"
alias htb="~/Tools/Custom/Bash/tmux_sessions/htb.sh"
alias oscp="~/Tools/Custom/Bash/tmux_sessions/oscp.sh"
alias xlogout="xfce4-session-logout --logout"
alias fwm="~/Tools/Custom/Bash/window_manager/fwm.sh"

# enable auto-suggestions based on the history
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    . /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    # change suggestion color
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# enable command-not-found if installed
if [ -f /etc/zsh_command_not_found ]; then
    . /etc/zsh_command_not_found
fi

# export PATH=~/.npm-global/bin:$PATH
if [[ ":$PATH:" != *":$HOME/.npm-global/bin:"* ]]; then
   export PATH="$HOME/.npm-global/bin:$PATH"
fi

# export PATH=$HOME/.cargo/bin:$PATH
if [[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]]; then
   export PATH="$HOME/.cargo/bin:$PATH"
fi

# export GOPATH=$HOME/go
if [ -z "$GOPATH" ]; then
   export GOPATH="$HOME/go"
fi

# export PATH=$PATH:$GOPATH/bin
if [[ ":$PATH:" != *":$GOPATH/bin:"* ]]; then
   export PATH="$PATH:$GOPATH/bin"
fi

# export $HOME/.local/bin
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
   export PATH="$HOME/.local/bin:$PATH"
fi

# export PYENV_ROOT="$HOME/.pyenv
if [ -z "$PYENV_ROOT" ]; then
   export PYENV_ROOT="$HOME/.pyenv"
fi

# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
if [[ -d "$PYENV_ROOT/bin" && ":$PATH:" != *":$PYENV_ROOT/bin:"* ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
fi

# eval "$(pyenv init -)
if command -v pyenv &> /dev/null; then
    eval "$(pyenv init -)"
fi
