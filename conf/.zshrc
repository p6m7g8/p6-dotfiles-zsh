p6dfz::init() {

  # bootstrap
  . $P6_DFZ_LIB_DIR/util.zsh
  . $P6_DFZ_LIB_DIR/modules.zsh
  . $P6_DFZ_LIB_DIR/theme.zsh

  p6dfz::util::user::init
  p6dfz::modules::init
  p6dfz::theme::init
}

p6dfz::init
