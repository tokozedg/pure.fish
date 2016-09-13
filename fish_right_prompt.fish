function dim; set_color    666; end
function off; set_color normal; end
function fst; set_color -o fa0; end
function snd; set_color -o 36f; end
function trd; set_color -o f06; end

function git::is_stashed
  command git rev-parse --verify --quiet refs/stash >/dev/null
end

function git::get_ahead_count
  echo (command git log ^/dev/null | grep '^commit' | wc -l | tr -d " ")
end

function git::branch_name
  command git symbolic-ref --short HEAD
end

function git::is_touched
  test -n (echo (command git status --porcelain))
end

function fish_right_prompt
  set -l code $status
  test $code -ne 0; and echo (dim)"("(trd)"$code"(dim)") "(off)

  if test -n "$SSH_CONNECTION"
     printf (trd)":"(dim)"$HOSTNAME "(off)
   end

  if git rev-parse 2> /dev/null
    git::is_stashed; and echo (trd)"^"(off)
    printf (snd)"("(begin
      if git::is_touched
        echo (trd)"*"(off)
      else
        echo ""
      end
    end)(fst)(git::branch_name)(snd)(begin
      set -l count (git::get_ahead_count)
        if test $count -eq 0
          echo ""
        else
          echo (trd)"+"(fst)$count
        end
    end)(snd)") "(off)
  end
  printf (fst)(date +%H:%M:%S)(off)" "
end
