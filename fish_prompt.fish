function _pwd_with_tilde
  echo $PWD | sed 's|^'$HOME'\(.*\)$|~\1|'
end

function _print_in_color
  set -l string $argv[1]
  set -l color  $argv[2]

  set_color $color
  printf $string
  set_color normal
end

function _prompt_color_for_status
  if test $argv[1] -eq 0
    echo magenta
  else
    echo red
  end
end

function __parse_git_branch -d "Parse current Git branch name"
  command git symbolic-ref --short HEAD ^/dev/null;
    or string split '\n' (command git show-ref --head -s --abbrev)[1]
end


function fish_prompt
  set -l last_status $status

  if test -n "$VIRTUAL_ENV"
    _print_in_color :(basename $VIRTUAL_ENV): yellow
  end

  set -l is_git_repository (command git rev-parse --is-inside-work-tree ^/dev/null)
  if test -n "$is_git_repository"
    _print_in_color /(__parse_git_branch)/ green
  end
  command test -L ./.chef/knife.rb
  if test $status -eq 0
    set -l server_name (command grep "^server_name" .chef/knife.rb | awk -F "'" '{print $2 }')
    if [ "$server_name" = "leaseweb" ]
      _print_in_color ":staging:" white
    end

    if [ "$server_name" = "production" ]
      _print_in_color ":production:" red
    end
  end

  _print_in_color (_pwd_with_tilde) blue

  _print_in_color " ❯ " (_prompt_color_for_status $last_status)
end
