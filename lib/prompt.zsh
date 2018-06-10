#####################################################################################################
#>
# p6dfz::prompt::init
#
#<
####################################################################################################
p6dfz::prompt::init() {

  p6dfz::util::exists "p6dfz::user::prompt" && p6dfz::user::prompt

  p6dfz::prompt::process

  export P6_DFZ_PROMPT=${(j: :)PromptLines}
}

#####################################################################################################
#>
# p6dfz::prompt::process
#
#<
####################################################################################################
p6dfz::prompt::process() {

  setopt prompt_subst
  PROMPT="\$(p6dfz::prompt::runtime $PromptLines[@])"
  PROMPT="
$PROMPT
"
}

p6dfz::prompt::runtime() {

  for line in $@; do
    local func="p6df::prompt::$line::line"
    if p6dfz::util::exists $func; then
      local cnt=$($func)
      [ -n "$cnt" ] && echo $cnt
    fi
  done
}

p6df::prompt::std::line() {

  local tty=$fg[cyan]%l$reset_color
  local user=$fg[blue]%n$reset_color
  local host=$fg[yellow]%M$reset_color

  local info="[$tty]$user@$host rv=%?"

  echo $info
}

p6df::prompt::dir::line() {

  local dir=$fg[green]%/$reset_color

  echo $dir
}

p6df::prompt::cloud::line() {

  local -a clouds=(aws gcp azure) # salesforce digitialocean rspace)

  local cloud
  for cloud in $clouds[@]; do
    p6dfz::util::exists p6df::prompt::${cloud}::line && p6df::prompt::${cloud}::line
  done
}

p6df::prompt::lang::line() {
  [ -n "${DISABLE_ENVS}" ] && return

  local -a langs=(python perl ruby go java scala lua R)
  local lang
  local str=""
  for lang in $langs[@]; do
    local prefix=$(cmd_2_envprefix "$lang")
    local func="p6df::prompt::${lang}::line"
    local cntv=""
    if p6dfz::util::exists $func; then
      cntv=$($func)
    else
      cntv="n/a"
    fi
    str="$str $prefix:$cntv"
  done

  str=${str## }
  echo "lang:\t$str"
}

p6df::prompt::vc::line() {

  local -a vcs=(git svn hg lp p4 cvs mg)
  local vc
  for vc in $vcs[@]; do
    p6dfz::util::exists p6df::prompt::${vc}::line && p6df::prompt::${vc}::line
  done
}
