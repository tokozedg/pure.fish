function fish_mode_prompt
  printf '['
  switch $fish_bind_mode
    case default
      set_color --bold red
      printf 'n'
    case insert
      set_color --bold green
      printf 'i'
    case visual
      set_color --bold magenta
      printf 'v'
  end
  set_color normal
  printf '] '
end function
