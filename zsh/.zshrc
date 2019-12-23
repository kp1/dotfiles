
# completion
fpath=(${ZDOTDIR:-$HOME}/zsh/completion $fpath)

# zplug
source $HOME/.zplug/init.zsh

zplug "sorin-ionescu/prezto"
# prezto modules
zplug "modules/environment", from:prezto
zplug "modules/terminal", from:prezto
zplug "modules/editor", from:prezto
zplug "modules/history", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/spectrum", from:prezto
zplug "modules/utility", from:prezto
zplug "modules/completion", from:prezto
zplug "modules/prompt", from:prezto
zplug "modules/command_not_found", from:prezto
zplug "modules/ruby", from:prezto

zstyle ':prezto:*:*' color 'yes'

zplug "romkatv/powerlevel10k", as:theme, depth:1 
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf"

zplug load

# cdr
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dir-max 1000
zstyle ':chpwd:*' recent-dirs-default yes
zstyle ':completion:*' recent-dirs-insert both

function fzf-cdr() {
  target_dir=`cdr -l | sed 's/^[^ ][^ ]*  *//' | fzf`
  target_dir=`echo ${target_dir/\~/$HOME}`
  if [ -n "$target_dir" ]; then
    cd $target_dir
  fi
}
alias cdd='fzf-cdr'

# git functions
[[ ! -f ~/.git-fzf.zsh ]] || source ~/.git-fzf.zsh
alias gad=fzf-git-add
alias gco=fzf-git-checkout
alias gdbr=fzf-git-delete-branch
# alias
alias agrep='ack'
alias diff='diff -u'
alias g='git'

if [ -x /usr/share/vim/vim80/macros/less.sh ];then
  alias less='/usr/share/vim/vim80/macros/less.sh'
fi

# other tools
[[ ! -f ${ZDOTDIR:-$HOME}/.p10k.zsh ]] || source ${ZDOTDIR:-$HOME}/.p10k.zsh
[[ ! -f ${ZDOTDIR:-$HOME}/.fzf.zsh ]] || source ${ZDOTDIR:-$HOME}/.fzf.zsh

# locally installed binary
[[ ! -d $HOME/bin ]] || path=($HOME/bin $path)

# Numeric Keypad
# Enter
bindkey -s "^[OM" "^M"
# + -  * / .
bindkey -s "^[Ok" "+"
bindkey -s "^[Om" "-"
bindkey -s "^[Oj" "*"
bindkey -s "^[Oo" "/"

# autosuggest
bindkey "^[ " autosuggest-accept
bindkey "^[^M" autosuggest-execute

# calcel opt
unsetopt extendedglob
