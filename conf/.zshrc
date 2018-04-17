p6dfz::init() {

  # bootstrap
  . $P6_DFZ/lib/util.zsh
  . $P6_DFZ/lib/modules.zsh
  . $P6_DFZ/lib/theme.zsh

  p6dfz::modules::init
  p6dfz::theme::init
}

p6dfz::init
