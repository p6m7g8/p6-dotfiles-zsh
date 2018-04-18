#!/usr/bin/env zsh -e

usage() {
    cat <<EOF
Usage: 
  zsh <(curl -s -o - https://raw.githubusercontent.com/p6m7g8/p6-dotfiles-zsh/master/bin/bootstrap.zsh)

Environment:

Args:

Options:
  --debug  |-d      Enable debugging
  --verbose|-v      Be verbose
  --help   |-h      Show this help message

  --local  |-l      Allow modules with *-private-* in them (GH repo should be private too)
EOF
    return
}

#####################################################################################################
#> 
# main
#
# see usage()
#<
#####################################################################################################
main() {

    # returns %Flags
    parse_cli "$@"

    # tmpdir
    TMPDIR=${TMPDIR:-${Flags[t]:-/tmp}
    
    ## Centralized ENV defs (pull-in)
    curl -s -o $TMPDIR/zshenv-xdg https://raw.githubusercontent.com/p6m7g8/p6dfz/master/conf/zshenv-xdg
    P6_DFZ_BOOTSTRAP=1 . $TMPDIR/zshenv-xdg

    # clone it
    rm -rf $P6_DFZ_CONFIG_DIR
    mkdir -p $P6_DFZ_CONFIG_DIR/..
    git clone -q https://github.com/p6m7g8/p6dfz $P6_DFZ_CONFIG_DIR
    
    # hook zsh
    rm -f $HOME/.zshenv
    ln -s P6_DFZ_ZSHENV_XDG_FILE $HOME/.zshenv
   
    # cleanup
    rm -f $TMPDIR/zshenv-xdg

    # reload
    exec $SHELL -li

    # don't get here
    return $status
}

main "$@"
