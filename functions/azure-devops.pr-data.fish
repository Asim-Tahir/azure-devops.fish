complete -c azure-devops.pr-data -s h -l help -d "Show help message"
complete -c azure-devops.pr-data -s r -l git-remote -d "Azure DevOps git remote name" -a "(git remote)"
complete -c azure-devops.pr-data -s R -l git-remote-url -d "Azure DevOps git remote URL" -a "(git remote get-url origin)"
complete -c azure-devops.pr-data -l id -d "Azure DevOps Pull request ID"
complete -c azure-devops.pr-data -s v -l api-version -d "Azure DevOps Pull request API version" -a "7.0" -a "7.1"

function azure-devops.pr-data -d "Get Azure DevOps Pull Request Data"
    # Default values for function arguments
    set -l _flag_id (fallback $AZURE_DEVOPS_FISH_PULL_REQUEST_ID)
    set -l _flag_git_remote (_azure-devops.util.fallback $AZURE_DEVOPS_FISH_GIT_REMOTE "origin")
    set -l _flag_api_version (_azure-devops.util.fallback $AZURE_DEVOPS_FISH_API_VERSION "7.0")

    # Parse function arguments
    argparse "h/help=?" "r/git-remote=" "R/git-remote-url=" "id=!_validate_int --min 0" "v/api-version=" -- $argv; or return

    if test "$DEBUG" = 1
        echo ""
        echo -e (set_color '#666')"[DEBUG::argument]"(set_color normal) (set_color yellow)"\$_flag_git_remote"(set_color normal)":" (set_color green)"\"$_flag_git_remote\""(set_color normal)
        echo -e (set_color '#666')"[DEBUG::argument]"(set_color normal) (set_color yellow)"\$_flag_git_remote_url"(set_color normal)":" (set_color green)"\"$_flag_git_remote_url\""(set_color normal)
        echo -e (set_color '#666')"[DEBUG::argument]"(set_color normal) (set_color yellow)"\$_flag_id"(set_color normal)":" (set_color green)"\"$_flag_id\""(set_color normal)
        echo -e (set_color '#666')"[DEBUG::argument]"(set_color normal) (set_color yellow)"\$_flag_api_version"(set_color normal)":" (set_color green)"\"$_flag_api_version\""(set_color normal)
    end

    if set -ql _flag_id
        if string match -rq '^[[:space:]]*$' -- $_flag_id
            echo -e (set_color red)"Required: Pull request ID is required."(set_color normal)
            echo ""
            echo "Example:"
            echo ""
            echo -e (set_color cyan)"azure-devops.pr-data"(set_color normal) (set_color '#AAA')"-w"(set_color normal) (set_color bryellow)"12345"(set_color normal)
            return 1
        else if not string match -rq '^[1-9][0-9]*$' -- $_flag_id
            echo ""
            echo -e (set_color red)"Invalid"(set_color normal) (set_color bryellow)"\"$_flag_id\""(set_color normal) (set_color red)"Pull request ID"(set_color normal)
            echo -e (set_color red)"Pull request ID should be a positive integer."(set_color normal)

            echo ""

            echo "Example:"
            echo ""
            echo -e (set_color cyan)"azure-devops.pr-data"(set_color normal) (set_color '#AAA')"--id"(set_color normal) (set_color bryellow)"12345"(set_color normal)
            return 1
        end
    end

    if set -ql _flag_git_remote
        git remote get-url $_flag_git_remote >/dev/null 2>&1

        if test $status -ne 0
            echo ""
            echo -e (set_color red)"Invalid"(set_color normal) (set_color green)"\"$_flag_git_remote\""(set_color normal) (set_color red)"git remote"(set_color normal)
            echo -e (set_color red)"Please specify valid git remote via"(set_color normal) (set_color cyan)"azure-devops.pr-data"(set_color normal) (set_color '#AAA')"[-r|--git-remote]"(set_color normal) (set_color green)"\"<remote-name>\""(set_color normal)
            echo ""
            echo -e "\$" (set_color cyan)"azure-devops.pr-data"(set_color normal) (set_color '#AAA')"-r"(set_color normal) (set_color green)"\"upstream\""(set_color normal)
            echo ""

            echo -e "Available git remotes:"
            set_color green
            git remote
            set_color normal

            return 2
        end

        if not set -ql _flag_git_remote_url
            set _flag_git_remote_url (_azure-devops.util.fallback $AZURE_DEVOPS_FISH_GIT_REMOTE_URL (git remote get-url $_flag_git_remote))
        end

        if test "$DEBUG" = 1
            echo -e (set_color '#666')"[DEBUG::argument]"(set_color normal) (set_color yellow)"\$_flag_git_remote_url"(set_color normal)":" (set_color green)"\"$_flag_git_remote_url\""(set_color normal)
            echo ""
        end
    end

    if set -ql _flag_help
        echo -e ""
        echo -e (set_color cyan)"azure-devops.pr-data"(set_color normal) (set_color BBB)"[OPTIONS]"(set_color normal)
        echo -e ""
        echo -e "Get Azure DevOps Pull Request Data"
        echo -e ""

        echo -e "Options:"
        echo -e ""

        echo -e (set_color '#AAA')"-h"(set_color normal) or (set_color '#AAA')"--help"(set_color normal) "- Show this help message"
        echo -e "    required: false"
        echo -e ""

        echo -e (set_color '#AAA')"-r"(set_color normal) or (set_color '#AAA')"--git-remote"(set_color normal) "- Azure DevOps git remote name"
        echo -e "    e.g:" (set_color green)"\"origin\""(set_color normal) or (set_color green)"\"upstream\""(set_color normal)
        echo -e "          Get available remote options from" "\""(set_color cyan)"git"(set_color normal) "remote\" command"
        echo -e "    required: false"
        echo -e "    default:" (set_color yellow)"\$AZURE_DEVOPS_FISH_GIT_REMOTE"(set_color normal) or (set_color green)"\"origin\""(set_color normal)
        echo -e ""

        echo -e (set_color '#AAA')"-R"(set_color normal) or (set_color '#AAA')"--git-remote-url"(set_color normal) "- Azure DevOps git remote URL."
        echo -e "    e.g:" (set_color --underline green)"\"https://dev.azure.com/<organization_name>/<project_name>/_git/<repository_name>"(set_color normal)
        echo -e "    required: false"
        echo -e "    default:" (set_color yellow)"\$AZURE_DEVOPS_FISH_GIT_REMOTE_URL"(set_color normal) or "\""(set_color cyan)"git"(set_color normal) "remote get-url origin\""
        echo -e ""

        echo -e (set_color '#AAA')"--id"(set_color normal) "- Azure DevOps pull request ID."
        echo -e "    e.g:" (set_color bryellow)"12345"(set_color normal)
        echo -e "    "(set_color --underline red)"required: true"(set_color normal)
        echo -e ""

        echo -e "$(set_color '#AAA')-v$(set_color normal) or $(set_color '#AAA')--api-version$(set_color normal) - Azure DevOps API version."
        echo -e "    e.g:" (set_color green)"\"7.0\""(set_color normal)", "(set_color green)"\"7.1\""(set_color normal)
        echo -e "    required: false"
        echo -e "    default:" (set_color green)"\"7.0\""(set_color normal)
        echo -e ""

        echo -e ""

        echo -e "Example:"
        echo -e ""
        echo -e (set_color cyan)"azure-devops.pr-data"(set_color normal) (set_color '#AAA')"--id"(set_color normal) (set_color bryellow)"12345"(set_color normal)
        echo -e (set_color cyan)"azure-devops.pr-data"(set_color normal) (set_color '#AAA')"--id"(set_color normal) (set_color bryellow)"12345"(set_color normal) (set_color '#AAA')"-R"(set_color normal) (set_color green)"\"https://dev.azure.com/TestOrg/Test_Project/_git/Test.Repo\""(set_color normal)
        echo -e (set_color cyan)"azure-devops.pr-data"(set_color normal) (set_color '#AAA')"--id"(set_color normal) (set_color bryellow)"12345"(set_color normal) (set_color '#AAA')"-r"(set_color normal) (set_color green)"\"upstream\""(set_color normal)
        return 0
    else if set -ql _flag_git_remote_url
        _azure-devops.util.remote-url-match $_flag_git_remote_url

        if test "$DEBUG" = 1
            echo -e (set_color '#666')"[DEBUG::regex::match]"(set_color normal) (set_color yellow)"\$azdo_org"(set_color normal)":" (set_color green)"\"$azdo_org\""(set_color normal)
            echo -e (set_color '#666')"[DEBUG::regex::match]"(set_color normal) (set_color yellow)"\$azdo_project"(set_color normal)":" (set_color green)"\"$azdo_project\""(set_color normal)
            echo -e (set_color '#666')"[DEBUG::regex::match]"(set_color normal) (set_color yellow)"\$azdo_repo"(set_color normal)":" (set_color green)"\"$azdo_repo\""(set_color normal)
            echo ""
        end

        if test -z "$azdo_org" -o -z "$azdo_project" -o -z "$azdo_repo"
            echo ""
            echo -e (set_color red)"Invalid"(set_color normal) "\""(set_color --underline)$_flag_git_remote_url(set_color normal)"\"" (set_color red)"git remote URL"(set_color normal)
            echo ""
            echo -e (set_color green)"Valid Azure DevOps git remote URLs:"(set_color normal)
            echo -e " -" (set_color --underline)"https://dev.azure.com/<organization_name>/<project_name>/_git/<repository_name>"(set_color normal)
            echo -e " -" (set_color --underline)"https://<organization_name>@dev.azure.com/<organization_name>/<project_name>/_git/<repository_name>"(set_color normal)
            echo -e " -" (set_color --underline)"git@ssh.dev.azure.com:v3/<organization_name>/<project_name>/<repository_name>"(set_color normal)
            return 2
        end

        set -g AZURE_DEVOPS_FISH_PULL_REQUEST_API_URL "https://dev.azure.com/$azdo_org/$azdo_project/_apis/git/repositories/$azdo_repo/pullRequests/$_flag_id?api-version=$_flag_api_version"

        if test "$DEBUG" = 1
            echo -e (set_color '#666')"[DEBUG::var]"(set_color normal) (set_color yellow)"\$AZURE_DEVOPS_FISH_PULL_REQUEST_API_URL"(set_color normal)":" (set_color green)"\"$AZURE_DEVOPS_FISH_PULL_REQUEST_API_URL\""(set_color normal)
            echo ""
        end

        echo $AZURE_DEVOPS_FISH_PULL_REQUEST_API_URL
    end
end
