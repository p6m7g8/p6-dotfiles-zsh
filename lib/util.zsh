# minimalistic - dispatch to modules

p6dfz::util::exists() { 
  local thing="$1" 
  type -f "$thing" > /dev/null 2>&1 
}

p6dfz::util::module_parse() {
  local module="$1"

  declare -gA repo

  repo[proto]=https
  repo[host]=github.com
  repo[org]=${module%%/*}
  repo[repo]=${module##*/}
  repo[path]=$repo[org]/$repo[repo]
  repo[version]=master
  repo[prefix]=p6df::modules::${repo[repo]##p6df-}
}

p6dfz::util::file_load() {
  local file="$1"

  if [[ -r $file ]]; then
    . $file
  fi
}
