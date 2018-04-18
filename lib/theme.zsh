p6dfz::theme::init() {

  typeset -g Theme=builtin
  if (( $+commands[p6dfz::user::theme] )); then
    p6dfz::user::theme
  fi
  echo Theme: $Theme
  
}

