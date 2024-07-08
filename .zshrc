# If you come from bash you might have to change your $PATH.
 export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
 CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
 HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
 zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
 ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
 COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
   # export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"
alias ll='ls -lh'
alias la='ls -A'
alias l='ls -CF'
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
export EDITOR=$VISUAL
export VISUAL=vim
ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi
export GPG_TTY=$(tty)
PATH="~/.local/bin:$PATH"
alias mutt='neomutt'

alias zshreload="source ~/.zshrc"
source $ZSH/oh-my-zsh.sh
#ZSH_THEME=powerline

source /usr/share/zsh/scripts/zplug/init.zsh
# zplug "dracula/zsh", as:theme
 zplug "jeffreytse/zsh-vi-mode"
# source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

set -o vi
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load 
if (( $+commands[zoxide] )); then
  eval "$(zoxide init --cmd "cd" zsh)"
else
  echo 'zoxide: command not found, please install it from https://github.com/ajeetdsouza/zoxide'
fi
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
#PROMPT='%F{green}%n@%m%f:%F{blue}%~%f%F{red}${vcs_info_msg_0_}%f%(!.#.%%) ' 
eval export POSH_THEME='' export POSH_SHELL_VERSION=$ZSH_VERSION export POSH_PID=$$ export POWERLINE_COMMAND="oh-my-posh" export CONDA_PROMPT_MODIFIER=false export POSH_PROMPT_COUNT=0 export ZLE_RPROMPT_INDENT=0 # set secondary prompt PS2="$(/usr/bin/oh-my-posh print secondary --config="$POSH_THEME" --shell=zsh)" function _set_posh_cursor_position() { # not supported in Midnight Commander # see https://github.com/JanDeDobbeleer/oh-my-posh/issues/3415 if [[ "false" != "true" ]] || [[ -v MC_SID ]]; then return fi local oldstty=$(stty -g) stty raw -echo min 0 local pos echo -en "[6n" > /dev/tty read -r -d R pos pos=${pos:2} # strip off the esc-[ local parts=(${(s:;:)pos}) stty $oldstty export POSH_CURSOR_LINE=${parts[1]} export POSH_CURSOR_COLUMN=${parts[2]} } # template function for context loading function set_poshcontext() { return } function prompt_ohmyposh_preexec() { if [[ "false" = "true" ]]; then printf "]133;C" fi omp_start_time=$(/usr/bin/oh-my-posh get millis) } function prompt_ohmyposh_precmd() { omp_last_error=$? local pipeStatus=(${pipestatus[@]}) omp_stack_count=${#dirstack[@]} omp_elapsed=-1 no_exit_code="true" if [ $omp_start_time ]; then local omp_now=$(/usr/bin/oh-my-posh get millis --shell=zsh) omp_elapsed=$(($omp_now-$omp_start_time)) no_exit_code="false" fi if [[ "${pipeStatus[-1]}" != "$omp_last_error" ]]; then pipeStatus=("$omp_last_error") fi count=$((POSH_PROMPT_COUNT+1)) export POSH_PROMPT_COUNT=$count set_poshcontext _set_posh_cursor_position eval "$(/usr/bin/oh-my-posh print primary --config="$POSH_THEME" --status="$omp_last_error" --pipestatus="${pipeStatus[*]}" --execution-time="$omp_elapsed" --stack-count="$omp_stack_count" --eval --shell=zsh --shell-version="$ZSH_VERSION" --no-status="$no_exit_code")" unset omp_start_time } # add hook functions autoload -Uz add-zsh-hook add-zsh-hook precmd prompt_ohmyposh_precmd add-zsh-hook preexec prompt_ohmyposh_preexec # perform cleanup so a new initialization in current session works if [[ "$(bindkey " ")" = *"_posh-tooltip"* ]]; then bindkey " " self-insert fi if [[ "$(zle -lL zle-line-init)" = *"_posh-zle-line-init"* ]]; then zle -N zle-line-init fi function _posh-tooltip() { # https://github.com/zsh-users/zsh-autosuggestions - clear suggestion to avoid keeping it after the newly inserted space if [[ "$(zle -lL autosuggest-clear)" ]]; then # only if suggestions not disabled (variable not set) if ! [[ -v _ZSH_AUTOSUGGEST_DISABLED ]]; then zle autosuggest-clear fi fi zle .self-insert # https://github.com/zsh-users/zsh-autosuggestions - fetch new suggestion after the space if [[ "$(zle -lL autosuggest-fetch)" ]]; then # only if suggestions not disabled (variable not set) if ! [[ -v _ZSH_AUTOSUGGEST_DISABLED ]]; then zle autosuggest-fetch fi fi # get the first word of command line as tip local tip=${${(MS)BUFFER##[[:graph:]]*}%%[[:space:]]*} # ignore an empty tip if [[ -z "$tip" ]]; then return fi local tooltip=$(/usr/bin/oh-my-posh print tooltip --config="$POSH_THEME" --shell=zsh --status="$omp_last_error" --command="$tip" --shell-version="$ZSH_VERSION") # ignore an empty tooltip if [[ -z "$tooltip" ]]; then return fi RPROMPT=$tooltip zle .reset-prompt } function _posh-zle-line-init() { [[ $CONTEXT == start ]] || return 0 # Start regular line editor. (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[1] zle .recursive-edit local -i ret=$? (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[2] eval "$(/usr/bin/oh-my-posh print transient --status="$omp_last_error" --execution-time="$omp_elapsed" --stack-count="$omp_stack_count" --config="$POSH_THEME" --eval --shell=zsh --shell-version="$ZSH_VERSION" --no-status="$no_exit_code")" zle .reset-prompt # Exit the shell if we receive EOT. if [[ $ret == 0 && $KEYS == $'\4' ]]; then exit fi if ((ret)); then # TODO (fix): this is not equal to sending a SIGINT, since the status code ($?) is set to 1 instead of 130. zle .send-break else # Enter zle .accept-line fi return ret } function enable_poshtooltips() { zle -N _posh-tooltip bindkey " " _posh-tooltip } function enable_poshtransientprompt() { zle -N zle-line-init _posh-zle-line-init # restore broken key bindings # https://github.com/JanDeDobbeleer/oh-my-posh/discussions/2617#discussioncomment-3911044 bindkey '^[[F' end-of-line bindkey '^[[H' beginning-of-line _widgets=$(zle -la) if [[ "${_widgets[(r)down-line-or-beginning-search]}" ]]; then bindkey '^[[B' down-line-or-beginning-search fi if [[ "${_widgets[(r)up-line-or-beginning-search]}" ]]; then bindkey '^[[A' up-line-or-beginning-search fi } if [[ "true" = "true" ]]; then enable_poshtooltips fi if [[ "true" = "true" ]]; then enable_poshtransientprompt fi if [[ "false" = "true" ]]; then echo "" fi if [[ "false" = "true" ]]; then /usr/bin/oh-my-posh upgrade fi

eval "$(oh-my-posh init zsh --config /usr/share/oh-my-posh/themes/dracula.omp.json)"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
