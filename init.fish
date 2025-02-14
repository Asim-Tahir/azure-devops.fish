# Oh My Fish initialization
# $path is only defined for oh-my-fish. home-manager activates this plugin by
# adding the full path of functions/ to fish_function_path, and then sourcing
# init.fish, so let's skip sourcing _azure_devops.init.fish before calling _azure_devops.init.
set -l _azure_devops_init_path "$path/functions/_azure_devops.init.fish"
if [ -f "$_azure_devops_init_path" ];
    source "$_azure_devops_init_path"
end

_azure_devops.init