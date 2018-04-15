#!/usr/bin/env zsh

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
# 
#
# see usage()
#<
#####################################################################################################
main() {

    TMPDIR=${TMPDIR:-/tmp}

    ## Centralized ENV defs (pull-in)
    curl -s -o $TMPDIR/zshenv-xdg https://raw.githubusercontent.com/p6m7g8/p6-dotfiles-zsh/master/conf/zshenv-xdg
    P6_BOOTSTRAP=1 . $TMPDIR/zshenv-xdg

    # clone it
    rm -rf $XDG_CONFIG_HOME/p6m7g8
    mkdir -p $XDG_CONFIG_HOME/p6m7g8
    git clone -q https://github.com/p6m7g8/p6-dotfiles-zsh $XDG_CONFIG_HOME/p6m7g8/p6-dotfiles-zsh
    
    # hook zsh
    rm -f $HOME/.zshenv
    ln -s $ZDOTDIR/zshenv-xdg $HOME/.zshenv

    # reload
    exec zsh -li

    # don't get here
    return $status
}

main "$@"
