p6dfz::modules::init() {

  typeset -gaU Plugins
  if (( $+commands[p6dfz::user::modules] )); then
    p6dfz::user::modules
  fi
  Plugins+=(core zsh) # required

  local plugin
  for plugin in $Plugins[@]; do
    echo "Plugin: $plugin"    
  done
}
