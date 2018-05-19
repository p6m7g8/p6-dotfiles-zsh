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
  PROMPT=
  local line
  for line in $PromptLines[@]; do
#    echo "p:[p6df::prompt::$line::line]"
    p6dfz::util::exists p6df::prompt::$line::line && cnt="\$(p6df::prompt::$line::line)" || cnt=$line
    PROMPT="$PROMPT
$cnt"
  done
  PROMPT="$PROMPT
"
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

p6df::prompt::lang::line() {

  echo lang::all
}

p6df::prompt::vc::line() {

  p6dfz::util::exists p6df::prompt::git::line && p6df::prompt::git::line || echo vc::git
}
