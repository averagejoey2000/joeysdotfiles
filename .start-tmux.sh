if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ]; then
    exec  tmuxinator start comfy ${USER} >/dev/null 2>&1
fi
