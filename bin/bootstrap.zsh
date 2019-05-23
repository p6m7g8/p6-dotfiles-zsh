#!/usr/bin/env zsh -e

usage() {
    cat <<EOF
Usage: 
  curl -s -O /tmp/bootstrap.zsh https://raw.githubusercontent.com/p6m7g8/p6dfz/master/bin/bootstrap.zsh)
  /tmp/bootstrap.zsh [org/repo]

Depends On:
  git and zsh must be in your PATH
  curl to download or whatever you use

Environment:
  HOME must be set to a valid existing home dir you have 755 to or better

Args:
  org/repo - a Github org/repo [defaults to pgollucci/home] containing a zsh-me file in the top level
             Any other files will also be symlinked to from ~
Options:
  --debug  |-d      Enable debugging
  --verbose|-v      Be verbose
  --help   |-h      Show this help message

  --local  |-l      Allow modules with *-private-* in them (GH repo should be private too)
EOF
    exit 0
}

#####################################################################################################
#> 
# parse_cli() 
#
# SIDE EFFECTS: %Flags
#
#<
#####################################################################################################
parse_cli() {
    # inherit "$@"

    if [ $# -gt 1 ]; then
        usage
    fi
 
    # only support 1 optional arg [org/repo] which defaults to pgollucci/home
    local org_repo="$1"

    [ -z "$org_repo" ] && org_repo="pgollucci/home"

    local org=$(echo $org_repo | cut -f 1 -d /)
    local repo=$(echo $org_repo | cut -f 2 -d /)

    declare -gA Flags
    Flags["org"]=$org
    Flags["repo"]=$repo
}

#####################################################################################################
#> 
# main
#
# see usage()
#<
#####################################################################################################
main() {

    local gh_dir="$HOME/src/github.com"

    # returns %Flags
    parse_cli "$@"

    # make org of "my" 'home' dir
    mkdir -p $gh_dir/$Flags["org"]

    # make p6 org
    local p6_org="p6m7g8"
    mkdir -p $gh_dir/$p6_org 

    # clone 3 repos
    local org_repo
    for org_repo in $p6_org/p6df-core $p6_org/p6dfz $Flags["org"]/$Flags["repo"]; do
        local dir="$gh_dir/$org_repo"
      
        echo "=====> $dir"
        if [ -d $dir ]; then
            ( cd $dir ; git pull )
        else
            git clone https://github.com/$org_repo $dir
        fi
    done

    # connect p6dfz to zsh init files
    (
        cd ~ ; 
        rm -f .zlogin .zlogout .zprofile .zshrc .zshenv
        ln -s $gh_dir/$p6_org/p6df-core/conf/zshenv-xdg .zshenv
        ln -s $gh_dir/$p6_org/p6df-core/conf/zshrc  .zshrc
    )

    # symlink to everything in $Flags["org"]/$Flags["repo"] from ~
    (
        cd ~ 
        local file
        for file in $(cd $gh_dir/$Flags["org"]/$Flags["repo"] ; git ls-files); do
            echo "~/$file -> $gh_dir/$Flags["org"]/$Flags["reop"]/$file"
            ln -fs $gh_dir/$Flags["org"]/$Flags["repo"]/$file .
        done
    )

    # reload
    exec zsh -li

    # don't get here
    return $status
}

main "$@"
