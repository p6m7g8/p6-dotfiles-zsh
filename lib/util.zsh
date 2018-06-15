# minimalistic - dispatch to modules

p6dfz::util::exists() {
  local thing="$1"
  type -f "$thing" > /dev/null 2>&1
}

p6dfz::util::module_parse() {
  local module="$1"

  declare -gA repo

  repo[repo]=${${module%%:*}##*/}
  repo[proto]=https
  repo[host]=github.com
  repo[org]=${module%%/*}
  repo[path]=$repo[org]/$repo[repo]
  repo[version]=master
  
  repo[module]=${repo[repo]##p6df-}
  repo[prefix]=p6df::modules::$repo[module]
  repo[sub]=${module##*:}

  repo[plugin]=${repo[sub]##*/}

  if [[ $repo[repo] =~ ^p6 ]]; then
    repo[load_path]=$repo[path]/init.zsh
  elif [[ $repo[org] = robbyrussell ]]; then
      if [[ $repo[sub] =~ lib ]]; then
	repo[load_path]=$repo[path]/$repo[sub].zsh
      else
	repo[load_path]=$repo[path]/$repo[repo].plugin.zsh
      fi
  elif [[ $repo[repo] = prezto ]]; then
      repo[load_path]=$repo[path]/$repo[sub]/init.zsh
      repo[extra_load_path]=$repo[path]/init.zsh
  else
    repo[load_path]=$repo[path]/$repo[plugin].plugin.zsh
  fi
}

export -a FILES
p6dfz::util::file_load() {
  local file="$1"

  if [[ -r $file ]]; then
    FILES+=($file)
    if p6dfz::util::exists p6_file_load; then
      p6_file_load $file
    else
      echo "===========> $file"
      . $file
    fi
  fi
}

p6dfz::util::path_if() {
  local dir="$1"

  if [[ -d $dir ]]; then
    path+=($dir)
  fi
}

p6dfz::util::cdpath_if() {
  local dir="$1"

  if [[ -d $dir ]]; then
    cdpath+=($dir)
  fi
}

p6dfz::util::user::init() {

  p6dfz::util::file_load $HOME/.zsh-me
}

p6dfz::util::pm::homebrew::install() {

  yes | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}
