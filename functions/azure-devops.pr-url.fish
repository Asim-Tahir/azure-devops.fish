# set -l _flag_source_repo_id "$AZURE_DEVOPS_FISH_SOURCE_REPO_ID"
# set -l _flag_target_repo_id "$AZURE_DEVOPS_FISH_SOURCE_REPO_ID"

# sourceRepositoryId
# targetRepositoryId

complete -c azure-devops.pr-url -s h -l help -d "Show help message"
complete -c azure-devops.pr-url -s R -l remote-url -d "Azure DevOps repository remote URL"
complete -c azure-devops.pr-url -s O -l remote-origin-url -d "Azure DevOps remote origin URL" -a "https://dev.azure.com https://(commandline -c).visualstudio.com"
complete -c azure-devops.pr-url -s o -l org-name -d "Azure DevOps organization name"
complete -c azure-devops.pr-url -s p -l project-name -d "Azure DevOps project name"
complete -c azure-devops.pr-url -s r -l repo-name -d "Azure DevOps repository name"
complete -c azure-devops.pr-url -s s -l source-branch -d "Azure DevOps pull request source branch" -a "(git branch --format='%(refname:short)')"
complete -c azure-devops.pr-url -s t -l target-branch -d "Azure DevOps pull request target branch" -a "(git branch --format='%(refname:short)')"

function azure-devops.pr-url -d "Create Azure DevOps Pull Request URL"
    # Helper functions
    function fallback -d "Fallback to first non-empty argument"
        for value in $argv
            if test "$value" != ""
                echo $value
                break
            end
        end
    end

    # Default values for function arguments
    # Git arguments
    set -l _flag_source_branch (git branch --show-current)
    set -l _flag_target_branch (git config --get init.defaultBranch)

    # Azure DevOps arguments
    # set -l _flag_remote_url (fallback $AZURE_DEVOPS_FISH_REMOTE_URL "")
    set -l _flag_remote_origin_url (fallback $AZURE_DEVOPS_FISH_REMOTE_ORIGIN_URL "https://dev.azure.com")
    # set -l _flag_org_name "$AZURE_DEVOPS_FISH_ORGANIZATION_NAME"
    # set -l _flag_project_name "$AZURE_DEVOPS_FISH_PROJECT_NAME"
    # set -l _flag_repo_name "$AZURE_DEVOPS_FISH_REPOSITORY_NAME"

    set AZURE_DEVOPS_FISH_GIT_REMOTE_URL (git remote get-url origin)

    function remote_url_match -d "Match URL is valid Azure DevOps remote repo URL"
        string match -r -- "https?:\/\/((?:[\w]+@)?(?<az_origin>dev\.azure\.com)\/(?<az_org>[\w\s]+)\/(?<az_project>[\w\s]+)\/_git\/(?<az_repo>[\w.]+)|(?<vs_origin>(?<vs_org>[\w-]+)\.visualstudio\.com)\/(?<vs_project>[\w\s]+)\/_git\/(?<vs_repo>[\w.]+))" $argv
    end

    # Parse function arguments
    argparse "h/help=?" "R/remote-url=?" "O/remote-origin-url=?" "o/org-name=?" "p/project-name=?" "r/repo-name=?" "s/source-branch=?" "t/target-branch=" -- $argv; or return

    if set -q _flag_help
        echo -e ""
        echo -e (set_color blue)"azure-devops.pr-url"(set_color normal) (set_color BBB)"[OPTIONS]"(set_color normal)
        echo -e ""
        echo -e "Create Azure DevOps Pull Request URL"
        echo -e ""

        echo -e "Options:"
        echo -e ""

        echo -e "$(set_color '#AAA')-h$(set_color normal) or $(set_color '#AAA')--help$(set_color normal) - Show this help message"
        echo -e "    required: false"
        echo -e ""

        echo -e "$(set_color '#AAA')-R$(set_color normal) or $(set_color '#AAA')--remote-url$(set_color normal) - Azure DevOps repository remote URL."
        echo -e "    e.g: $(set_color --underline)https://dev.azure.com/<organization_name>/<project_name>/_git/<repository_name>$(set_color normal) or $(set_color --underline)https://<organization_name>.visualstudio.com/<project_name>/_git/<repository_name>$(set_color normal)"
        echo -e "    required: false"
        echo -e ""

        echo -e "$(set_color '#AAA')-O$(set_color normal) or $(set_color '#AAA')--remote-origin-url$(set_color normal) - Azure DevOps remote origin URL."
        echo -e "    e.g: $(set_color --underline)https://dev.azure.com$(set_color normal) or $(set_color --underline)https://<organization_name>.visualstudio.com$(set_color normal)"
        echo -e "    required: false"
        echo -e "    default: $(set_color --underline)https://dev.azure.com$(set_color normal)"
        echo -e ""

        echo -e "$(set_color '#AAA')-o$(set_color normal) or $(set_color '#AAA')--org-name$(set_color normal) - Azure DevOps organization name."
        echo -e "    e.g: <organization_name> from $(set_color --underline)https://dev.azure.com/<organization_name>$(set_color normal) or $(set_color --underline)https://<organization_name>.visualstudio.com$(set_color normal)"
        echo -e "    required: false"
        echo -e "    default: \$AZURE_DEVOPS_FISH_ORGANIZATION_NAME"
        echo -e ""

        echo -e "$(set_color '#AAA')-p$(set_color normal) or $(set_color '#AAA')--project-name$(set_color normal) - Azure DevOps project name."
        echo -e "    e.g: <project_name> from $(set_color --underline)https://dev.azure.com/<organization_name>/<project_name>$(set_color normal) or $(set_color --underline)https://<organization_name>.visualstudio.com/<project_name>$(set_color normal)"
        echo -e "    required: false"
        echo -e "    default: \$AZURE_DEVOPS_FISH_PROJECT_NAME"
        echo -e ""

        echo -e "$(set_color '#AAA')-r$(set_color normal) or $(set_color '#AAA')--repo-name$(set_color normal) - Azure DevOps repository name"
        echo -e "    e.g:  <repository_name> from $(set_color --underline)https://dev.azure.com/<organization_name>/<project_name>/_git/<repository_name>$(set_color normal) or $(set_color --underline)https://<organization_name>.visualstudio.com/<project_name>/_git/<repository_name>$(set_color normal)"
        echo -e "    required: false"
        echo -e "    default: \$AZURE_DEVOPS_FISH_REPOSITORY_NAME"
        echo -e ""

        echo -e "$(set_color '#AAA')-s$(set_color normal) or $(set_color '#AAA')--source-branch$(set_color normal) - Azure DevOps pull request source branch name."
        echo -e "    e.g: feature/my-awesome-feature"
        echo -e "    required: false"
        echo -e "    default: `git branch --show-current`"
        echo -e ""

        echo -e "$(set_color '#AAA')-t$(set_color normal) or $(set_color '#AAA')--target-branch$(set_color normal) - Azure DevOps pull request target branch name."
        echo -e "    e.g: main"
        echo -e "    required: false"
        echo -e "    default: `git config --get init.defaultBranch`"
        echo -e ""

        echo -e ""

        echo -e "Example:"
        echo -e ""
        echo -e "$(set_color blue)azure-devops.pr-url$(set_color normal) -s feature/my-awesome-feature -t main -R https://dev.azure.com/TestOrg/Test_Project/_git/Test.Repo"
        echo -e "$(set_color blue)azure-devops.pr-url$(set_color normal) -t main -o TestOrg -p Test_Project -r Test.Repo"
        return 0
    else if set -q AZURE_DEVOPS_FISH_REMOTE_URL and not remote_url_match $AZURE_DEVOPS_FISH_REMOTE_URL
        echo ""
        echo -e "$(set_color red)Invalid $(set_color '#AAA')\$AZURE_DEVOPS_FISH_REMOTE_URL$(set_color normal)=$AZURE_DEVOPS_FISH_REMOTE_URL\"$_flag_remote_url\"$(set_color red) enviroment variable.$(set_color normal)"
        echo ""
        echo -e "$(set_color green)Valid remote URLs:$(set_color normal)"
        echo -e " - $(set_color --underline)https://dev.azure.com/<organization_name>/<project_name>/_git/<repository_name>$(set_color normal)"
        echo -e " - $(set_color --underline)https://<organization_name>.visualstudio.com/<project_name>/_git/<repository_name>$(set_color normal)"
        return 2
    else if set -q _flag_remote_url and not remote_url_match $_flag_remote_url
        echo ""
        echo -e "$(set_color red)Invalid $(set_color '#AAA')-R$(set_color normal), $(set_color '#AAA')--remote-url$(set_color normal)=\"$_flag_remote_url\"$(set_color red) argument.$(set_color normal)"
        echo ""
        echo -e "$(set_color green)Valid remote URLs:$(set_color normal)"
        echo -e " - $(set_color --underline)https://dev.azure.com/<organization_name>/<project_name>/_git/<repository_name>$(set_color normal)"
        echo -e " - $(set_color --underline)https://<organization_name>.visualstudio.com/<project_name>/_git/<repository_name>$(set_color normal)"
        return 2
    else if set -q AZURE_DEVOPS_FISH_GIT_REMOTE_URL
        if remote_url_match $AZURE_DEVOPS_FISH_GIT_REMOTE_URL
            set _flag_remote_url $AZURE_DEVOPS_FISH_GIT_REMOTE_URL
        else
            # TODO:  write info message that remote is not azure devops repo
            echo ""
            echo -e "$(set_color red)Invalid $(set_color '#AAA')\$AZURE_DEVOPS_FISH_GIT_REMOTE_URL$(set_color normal)=\"$AZURE_DEVOPS_FISH_GIT_REMOTE_URL\"$(set_color red) enviroment variable.$(set_color normal)"
            echo ""
            echo -e "$(set_color green)Valid remote URLs:$(set_color normal)"
            echo -e " - $(set_color --underline)https://dev.azure.com/<organization_name>/<project_name>/_git/<repository_name>$(set_color normal)"
            echo -e " - $(set_color --underline)https://<organization_name>.visualstudio.com/<project_name>/_git/<repository_name>$(set_color normal)"
            return 2
        end
    else if set -q _flag_remote_origin_url and set -q _flag_org_name and set -q _flag_project_name and set -q _flag_repo_name
        switch $_flag_remote_origin_url
            case "https://dev.azure.com"
                set _flag_remote_url "$_flag_remote_origin_url/$_flag_org_name/$_flag_project_name/_git/$_flag_repo_name"
            case "https://*.visualstudio.com"
                set _flag_remote_url "$_flag_remote_origin_url/$_flag_project_name/_git/$_flag_repo_name"
            case "*"
                set _flag_remote_url "$_flag_remote_origin_url/$_flag_org_name/$_flag_project_name/_git/$_flag_repo_name"
        end
    else
        # TODO:  print remote url and its parts invalid
    end

    set AZURE_DEVOPS_FISH_PULL_REQUEST_URL "$_flag_remote_url/pullrequestcreate?sourceRef=$_flag_source_branch&targetRef=$_flag_target_branch"

    echo -e "$AZURE_DEVOPS_FISH_PULL_REQUEST_URL"
end
