#!/usr/bin/env zsh -e

usage() {
    cat <<EOF
Usage: 
  zsh <(curl -s -o - https://raw.githubusercontent.com/p6m7g8/p6dfz/master/bin/bootstrap.zsh)

Depends On:
  git and zsh must be in your PATH

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

    mkdir -p ~/src/p6m7g8
    rm -rf ~/src/p6m7g8/p6df-core
    git clone -q https://github.com/p6m7g8/p6df-core ~/src/p6m7g8/p6df-core
    (
        cd ~ ; 
        rm -f .zlogin .zlogout .zprofile .zshrc .zshenv
        ln -s ~/src/p6m7g8/p6df-core/conf/zshenv-xdg .zshenv
        ln -s ~/src/p6m7g8/p6df-core/conf/zshrc  .zshrc
    )

    # reload
    exec zsh -li

    # don't get here
    return $status
}

main "$@"
