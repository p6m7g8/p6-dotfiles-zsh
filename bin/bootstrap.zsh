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
  org/repo - a Github $org/$repo [defaults to pgollucci/home] containing a .zsh-me file in the top level

Options:
  --debug   |-d      Enable debugging
  --verbose |-v      Be verbose
  --help    |-h      Show this help message

  --local   |-l      Allow modules with *-private-* in them (GH repo SHOULD be private too)
                     By default also clone $org/$repo-private
EOF
    exit 0
}

#####################################################################################################
#>
# reload()
#
# reloads configs
#<
#####################################################################################################
reload() {

    . ~/.zshenv
    . ~/.zshrc
    p6df::init
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

    # XXX: getopts

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

    Flags["local"]=1
}

#####################################################################################################
#>
# main
#
# see usage()
#<
#####################################################################################################
main() {

    # XXX: this lines up with GOPATH=$HOME but goenv moves this to go/V/src so we symlink it and forget it
    # XXX: see p6df-go
    local gh_dir="$HOME/src/github.com"

    # returns %Flags
    parse_cli "$@"

    # make org of "my" 'home' dir
    mkdir -p $gh_dir/$Flags["org"]

    # make p6 org
    local p6_org="p6m7g8"
    mkdir -p $gh_dir/$p6_org

    # clone repos
    local -aU repos=($p6_org/p6df-core $p6_org/p6dfz $Flags["org"]/$Flags["repo"])
    if [[ $Flags["local"] = "1" ]]; then
	repos+=($Flags["org"]/$Flags["repo"]-private)
    fi

    local org_repo
    for org_repo in $repos[@]; do
	local dir="$gh_dir/$org_repo"

	echo "=====> $dir"
	if [ -d $dir ]; then
	    ( cd $dir ; git pull )
	else
	    git clone https://github.com/$org_repo $dir
	fi
    done

    # start sub-shell in ~ for path ease
    (
	cd ~ ;

	# connect p6dfz to zsh init files
	rm -f .zlogin .zlogout .zprofile .zshrc .zshenv
	ln -fs $gh_dir/$p6_org/p6df-core/conf/zshenv-xdg .zshenv
	ln -fs $gh_dir/$p6_org/p6df-core/conf/zshrc  .zshrc

	# connect "my" config
	ln -fs $gh_dir/$Flags["org"]/$Flags["repo"]/.zsh-me .
    )

    # reload
    reload

    # pull down code
    p6df::modules::fetch
    reload

    # run symiinks
    p6df::modules::symlink

    # XXX: installing external deps and optionally langs is 100% but takes too long
    echo "p6df::modules::external_deps"
    echo "[p6df::modules::langs]"

    reload

    # cleanup
    unset Flags

    return $status
}

main "$@"
