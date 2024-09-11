# If you come from bash you might have to change your $PATH.
 export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
 # ruby gems for vimgolf
# export PATH=/home/averagejoey2000/.local/share/gem/ruby/3.0.0/bin:$PATH

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
 #ENABLE_CORRECTION="true"

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
    source ~/.aliases.zsh
export EDITOR=$VISUAL
export VISUAL=vim
# use this if you want it to be impossible to open terminal without tmux
# source ~/.start-tmux.sh
# use this if you want to easily start tmux
alias tms="tmuxinator start comfy"
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
#compdef glow

# zsh completion for glow                                 -*- shell-script -*-

__glow_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_glow()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16

    local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace
    local -a completions

    __glow_debug "\n========= starting completion logic =========="
    __glow_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __glow_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __glow_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., glow -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __glow_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __glow_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __glow_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __glow_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __glow_debug "No directive found.  Setting do default"
        directive=0
    fi

    __glow_debug "directive: ${directive}"
    __glow_debug "completions: ${out}"
    __glow_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __glow_debug "Completion received error. Ignoring completions."
        return
    fi

    local activeHelpMarker="_activeHelp_ "
    local endIndex=${#activeHelpMarker}
    local startIndex=$((${#activeHelpMarker}+1))
    local hasActiveHelp=0
    while IFS='\n' read -r comp; do
        # Check if this is an activeHelp statement (i.e., prefixed with $activeHelpMarker)
        if [ "${comp[1,$endIndex]}" = "$activeHelpMarker" ];then
            __glow_debug "ActiveHelp found: $comp"
            comp="${comp[$startIndex,-1]}"
            if [ -n "$comp" ]; then
                compadd -x "${comp}"
                __glow_debug "ActiveHelp will need delimiter"
                hasActiveHelp=1
            fi

            continue
        fi

        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab="$(printf '\t')"
            comp=${comp//$tab/:}

            __glow_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    # Add a delimiter after the activeHelp statements, but only if:
    # - there are completions following the activeHelp statements, or
    # - file completion will be performed (so there will be choices after the activeHelp)
    if [ $hasActiveHelp -eq 1 ]; then
        if [ ${#completions} -ne 0 ] || [ $((directive & shellCompDirectiveNoFileComp)) -eq 0 ]; then
            __glow_debug "Adding activeHelp delimiter"
            compadd -x "--"
            hasActiveHelp=0
        fi
    fi

    if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
        __glow_debug "Activating nospace."
        noSpace="-S ''"
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __glow_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subdir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __glow_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __glow_debug "Listing directories in ."
        fi

        local result
        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        result=$?
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
        return $result
    else
        __glow_debug "Calling _describe"
        if eval _describe "completions" completions $flagPrefix $noSpace; then
            __glow_debug "_describe found some completions"

            # Return the success of having called _describe
            return 0
        else
            __glow_debug "_describe did not find completions."
            __glow_debug "Checking if we should do file completion."
            if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
                __glow_debug "deactivating file completion"

                # We must return an error code here to let zsh know that there were no
                # completions found by _describe; this is what will trigger other
                # matching algorithms to attempt to find completions.
                # For example zsh can match letters in the middle of words.
                return 1
            else
                # Perform file completion
                __glow_debug "Activating file completion"

                # We must return the result of this command, so it must be the
                # last command, or else we must store its result to return it.
                _arguments '*:filename:_files'" ${flagPrefix}"
            fi
        fi
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_glow" ]; then
    _glow
fi
eval export POSH_THEME='' export POSH_SHELL_VERSION=$ZSH_VERSION export POSH_PID=$$ export POWERLINE_COMMAND="oh-my-posh" export CONDA_PROMPT_MODIFIER=false export POSH_PROMPT_COUNT=0 export ZLE_RPROMPT_INDENT=0 # set secondary prompt PS2="$(/usr/bin/oh-my-posh print secondary --config="$POSH_THEME" --shell=zsh)" function _set_posh_cursor_position() { # not supported in Midnight Commander # see https://github.com/JanDeDobbeleer/oh-my-posh/issues/3415 if [[ "false" != "true" ]] || [[ -v MC_SID ]]; then return fi local oldstty=$(stty -g) stty raw -echo min 0 local pos echo -en "[6n" > /dev/tty read -r -d R pos pos=${pos:2} # strip off the esc-[ local parts=(${(s:;:)pos}) stty $oldstty export POSH_CURSOR_LINE=${parts[1]} export POSH_CURSOR_COLUMN=${parts[2]} } # template function for context loading function set_poshcontext() { return } function prompt_ohmyposh_preexec() { if [[ "false" = "true" ]]; then printf "]133;C" fi omp_start_time=$(/usr/bin/oh-my-posh get millis) } function prompt_ohmyposh_precmd() { omp_last_error=$? local pipeStatus=(${pipestatus[@]}) omp_stack_count=${#dirstack[@]} omp_elapsed=-1 no_exit_code="true" if [ $omp_start_time ]; then local omp_now=$(/usr/bin/oh-my-posh get millis --shell=zsh) omp_elapsed=$(($omp_now-$omp_start_time)) no_exit_code="false" fi if [[ "${pipeStatus[-1]}" != "$omp_last_error" ]]; then pipeStatus=("$omp_last_error") fi count=$((POSH_PROMPT_COUNT+1)) export POSH_PROMPT_COUNT=$count set_poshcontext _set_posh_cursor_position eval "$(/usr/bin/oh-my-posh print primary --config="$POSH_THEME" --status="$omp_last_error" --pipestatus="${pipeStatus[*]}" --execution-time="$omp_elapsed" --stack-count="$omp_stack_count" --eval --shell=zsh --shell-version="$ZSH_VERSION" --no-status="$no_exit_code")" unset omp_start_time } # add hook functions autoload -Uz add-zsh-hook add-zsh-hook precmd prompt_ohmyposh_precmd add-zsh-hook preexec prompt_ohmyposh_preexec # perform cleanup so a new initialization in current session works if [[ "$(bindkey " ")" = *"_posh-tooltip"* ]]; then bindkey " " self-insert fi if [[ "$(zle -lL zle-line-init)" = *"_posh-zle-line-init"* ]]; then zle -N zle-line-init fi function _posh-tooltip() { # https://github.com/zsh-users/zsh-autosuggestions - clear suggestion to avoid keeping it after the newly inserted space if [[ "$(zle -lL autosuggest-clear)" ]]; then # only if suggestions not disabled (variable not set) if ! [[ -v _ZSH_AUTOSUGGEST_DISABLED ]]; then zle autosuggest-clear fi fi zle .self-insert # https://github.com/zsh-users/zsh-autosuggestions - fetch new suggestion after the space if [[ "$(zle -lL autosuggest-fetch)" ]]; then # only if suggestions not disabled (variable not set) if ! [[ -v _ZSH_AUTOSUGGEST_DISABLED ]]; then zle autosuggest-fetch fi fi # get the first word of command line as tip local tip=${${(MS)BUFFER##[[:graph:]]*}%%[[:space:]]*} # ignore an empty tip if [[ -z "$tip" ]]; then return fi local tooltip=$(/usr/bin/oh-my-posh print tooltip --config="$POSH_THEME" --shell=zsh --status="$omp_last_error" --command="$tip" --shell-version="$ZSH_VERSION") # ignore an empty tooltip if [[ -z "$tooltip" ]]; then return fi RPROMPT=$tooltip zle .reset-prompt } function _posh-zle-line-init() { [[ $CONTEXT == start ]] || return 0 # Start regular line editor. (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[1] zle .recursive-edit local -i ret=$? (( $+zle_bracketed_paste )) && print -r -n - $zle_bracketed_paste[2] eval "$(/usr/bin/oh-my-posh print transient --status="$omp_last_error" --execution-time="$omp_elapsed" --stack-count="$omp_stack_count" --config="$POSH_THEME" --eval --shell=zsh --shell-version="$ZSH_VERSION" --no-status="$no_exit_code")" zle .reset-prompt # Exit the shell if we receive EOT. if [[ $ret == 0 && $KEYS == $'\4' ]]; then exit fi if ((ret)); then # TODO (fix): this is not equal to sending a SIGINT, since the status code ($?) is set to 1 instead of 130. zle .send-break else # Enter zle .accept-line fi return ret } function enable_poshtooltips() { zle -N _posh-tooltip bindkey " " _posh-tooltip } function enable_poshtransientprompt() { zle -N zle-line-init _posh-zle-line-init # restore broken key bindings # https://github.com/JanDeDobbeleer/oh-my-posh/discussions/2617#discussioncomment-3911044 bindkey '^[[F' end-of-line bindkey '^[[H' beginning-of-line _widgets=$(zle -la) if [[ "${_widgets[(r)down-line-or-beginning-search]}" ]]; then bindkey '^[[B' down-line-or-beginning-search fi if [[ "${_widgets[(r)up-line-or-beginning-search]}" ]]; then bindkey '^[[A' up-line-or-beginning-search fi } if [[ "true" = "true" ]]; then enable_poshtooltips fi if [[ "true" = "true" ]]; then enable_poshtransientprompt fi if [[ "false" = "true" ]]; then echo "" fi if [[ "false" = "true" ]]; then /usr/bin/oh-my-posh upgrade fi

source ~/.op.zsh

eval "$(oh-my-posh init zsh --config /usr/share/oh-my-posh/themes/dracula.omp.json)"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
