function check-git-repository {
  git remote > /dev/null
  return $?
}

function fzf-git-add {
  check-git-repository || return $?

  local selected=$(git status -s -uall | awk '{if (substr($0,2,1) !~ / /) print $0}' |
    fzf -m --reverse --preview-window up:`expr $LINES / 2` --exit-0 \
      --preview="[[ {} == '??'* ]] && echo {} | awk '{print \$2 }' | xargs colordiff -u /dev/null || echo {} | awk '{print \$2}' | xargs git diff --color" |
    awk '{print $2}')
  if [[ -n "$selected" ]]; then
    selected=$(tr "\n" " " <<< $selected)
    git add $(echo $selected)
    echo "Completed"
  fi
}

function fzf-git-checkout {
  check-git-repository || return $?

  local branches=$(unbuffer git for-each-ref \
    --format='%(HEAD) %(if)%(HEAD)%(then)%(color:green)%(refname:short)%(color:reset)%(else)%(refname:short)%(end)%(if) %(upstream:short) %(then) -> %(color:red)%(upstream:short)%(color:reset) %(color:cyan)%(upstream:track)%(color:reset) %(end)' \
    refs/heads/)
  if [[ -n $(git remote) ]]; then
    branches+="\n"
    branches+=$(unbuffer git for-each-ref \
      --format='  %(color:red)%(refname:short)%(color:reset)' \
      refs/remotes/)
  fi
  local branch=$(echo $branches | fzf --exit-0 --reverse --ansi \
    --preview-window up:`expr $LINES / 2` \
    --preview="echo {} | awk '{print substr(\$0, 3)}' | awk '{print \$1}' | xargs git plog -20")
  [[ $branch == "" ]] && return
  branch=$(echo $branch | awk '{print substr($0,3)}' | awk '{print $1}')
  local refs=$(git show-ref $branch | awk '{print $2}')
  if [[ $refs == "refs/remotes/"* ]];then
    # remote branch
    b=$(echo $branch | sed "s#[^/]*/##")
    git checkout -b $b $branch 2> /dev/null || echo "'$b' is already exist."; git checkout $b
  else
    git checkout $branch
  fi
}

function fzf-git-delete-branch {
  check-git-repository || return $?

  # parse option
  # -D : force delete
  local -A opthash
  zparseopts -D -A opthash -- D

  local branches=$(unbuffer git for-each-ref \
    --format='%(HEAD) %(if)%(HEAD)%(then)%(color:green)%(refname:short)%(color:reset)%(else)%(refname:short)%(end)%(if) %(upstream:short) %(then) -> %(color:red)%(upstream:short)%(color:reset) %(color:cyan)%(upstream:track)%(color:reset) %(end)' \
    refs/heads/)
  local selected=$(echo $branches | fzf -m --exit-0 --reverse --ansi \
    --preview-window up:`expr $LINES / 2` \
    --preview="echo {} | awk '{print substr(\$0, 3)}' | awk '{print \$1}' | xargs git plog -20")
  [[ $selected == "" ]] && return
  selected=$(echo $selected |
    awk '{print substr($0,3)}' |
    awk '{print $1}' |
    tr "\n" " ")
  if [[ -n "${opthash[(i)-D]}" ]] &&
    (echo -n "force delete. OK?(y/N)"; read -q); then
    git branch -D `echo $selected`
  else
    git branch -d `echo $selected`
  fi
}

