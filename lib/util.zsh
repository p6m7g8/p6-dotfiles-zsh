# minimalistic - dispatch to modules

p6dfz::util::exists() { 
  local thing="$1" 
  type -f "$thing" > /dev/null 2>&1 
}

p6dfz::util::module_parse() {
  local module="$1"

  declare -gA repo

  local _t=${module%%:*}
  repo[repo]=${_t##*/}
  repo[proto]=https
  repo[host]=github.com
  repo[org]=${module%%/*}
  repo[path]=$repo[org]/$repo[repo]
  repo[version]=master

  repo[prefix]=p6df::modules::${repo[repo]##p6df-}
  repo[sub]=${module##*:}

  repo[plugin]=${repo[sub]##*/}
}

typeset -AU Files
p6dfz::util::file_load() {
  local file="$1"

  if [[ -r $file ]]; then
    . $file
    Files[$file]=1
  fi
}

p6dfz::util::path_if() {
  local dir="$1"

  if [[ -d $dir ]]; then
    path+=($dir)
  fi
}

