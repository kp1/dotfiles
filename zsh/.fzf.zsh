# Setup fzf
# ---------
if [[ ! "$PATH" == */home/kp/.zplug/repos/junegunn/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/kp/.zplug/repos/junegunn/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/kp/.zplug/repos/junegunn/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/kp/.zplug/repos/junegunn/fzf/shell/key-bindings.zsh"
