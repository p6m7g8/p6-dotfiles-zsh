#!/usr/bin/env zsh -e

usage() {
    cat <<EOF
Usage: 
  zsh <(curl -s -o - https://raw.githubusercontent.com/p6m7g8/p6dfz/master/bin/bootstrap.zsh)

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
#    parse_cli "$@"

    # tmpdir
    TMPDIR=${TMPDIR:-${Flags[t]:-/tmp}}

    mkdir -p ~/src/p6m7g8
    git -q clone https://github.com/p6m7g8/p6df-core ~/src/p6m7g8
    (
        cd ~ ; 
        rm -f .zlogin .zlogout .zprofile .zshrc
        ln -s ~/src/p6m7g8/p6df-core/conf/zshenv-xdg .zshenv
        ln -s ~/src/p6m7g8/p6df-core/conf/zshrc  .zshrc
    )

    # reload
    exec $SHELL -li

    # don't get here
    return $status
}

main "$@"
