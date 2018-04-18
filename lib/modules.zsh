#####################################################################################################
#>
# p6dfz::modules::init
#
# entry from .zshrc
# 
# create a Global Modules array
#   allow hook p6dfz::user::modules to modify Modules
# export a space seperated ENV of modules asked for
#
# Return
#   true
#<
####################################################################################################
p6dfz::modules::init() {

  declare -gaU Modules
  local -aU required_modules=(p6m7g8/p6df-core p6m7g8/p6df-zsh)

  p6dfz::util::exists "p6dfz::user::modules" && p6dfz::user::modules

  Modules=($required_modules[@] $Modules[@])
  local module
  for module in $Modules[@]; do
      p6dfz::module::load $module
  done

  export P6_DFZ_MODULES=${(j: :)Modules}
}

p6dfz::modules::external_init() {
    
  declare -aU Modules
  if [ -n "$1" ]; then
    Modules=($1)
  else
    Modules=(${(s/ /)P6_DFZ_MODULES})
  fi

  local module
  for module in $Modules[@]; do
      # %repo
      p6dfz::util::module_parse "$module"

      ## install external software
      $repo[prefix]::external
      
      ## @ModuleDeps
      local -aU ModuleDeps
      $repo[prefix]::deps 
      
      local dep
      for dep in $ModuleDeps[@]; do
        p6dfz::modules::external_init $dep
      done
  done
}

p6dfz::module::load() {
  local module="$1"
    
  # %repo
  p6dfz::util::module_parse "$module"
  
  # load myself
  p6dfz::util::file_load $P6_DFZ_DATA_PARENT/$repo[path]/init.zsh
 
  ## @ModuleDeps
  local -aU ModuleDeps
  $repo[prefix]::deps >/dev/null 2>&1
  
  local dep
  for dep in $ModuleDeps[@]; do
      p6dfz::util::exists "$repo[prefix]::version" || p6dfz::module::load $dep
  done
  
  # cleanup
  unset ModuleDeps
  unset repo
}

p6dfz::module::fetch() {
  local module="$1"

}
