complete -c azure-devops.pr-url -s h -l help -d "Show help message"
complete -c azure-devops.pr-url -s r -l git-remote -d "Azure DevOps git remote name" -a "(git remote)"
complete -c azure-devops.pr-url -s R -l git-remote-url -d "Azure DevOps git remote URL" -a "(git remote get-url origin)"
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

    function azure_devops_remote_url_match -d "Parse given Azure DevOps remote URL" -a url
        # Try HTTP regexp match first
        set -l matches (string match -r "https?:\/\/(?:[\w]+@)?dev\.azure\.com\/(?<azdo_org>[\w\.\- %20]+)\/(?<azdo_project>[\w\.\- %20]+)\/_git\/(?<azdo_repo>[\w\.\- %20]+)" -- $url)

        if test $status -eq 0
            # Set the matched groups in parent scope
            set -g azdo_org $matches[2]
            set -g azdo_project $matches[3]
            set -g azdo_repo $matches[4]

            if test "$DEBUG" = 1
                echo -e (set_color '#666')"[DEBUG::regexp::http]"(set_color normal) (set_color yellow)"\$azdo_org"(set_color normal)":" (set_color green)"\"$azdo_org\""(set_color normal)
                echo -e (set_color '#666')"[DEBUG::regexp::http]"(set_color normal) (set_color yellow)"\$azdo_project"(set_color normal)":" (set_color green)"\"$azdo_project\""(set_color normal)
                echo -e (set_color '#666')"[DEBUG::regex::http]"(set_color normal) (set_color yellow)"\$azdo_repo"(set_color normal)":" (set_color green)"\"$azdo_repo\""(set_color normal)
                echo ""
            end

            if test -n "$azdo_org" -a -n "$azdo_project" -a -n "$azdo_repo"
                return 0
            end
        end

        # Try SSH regexp match if HTTP regexp didn't match
        set matches (string match -r "git@ssh\.dev\.azure\.com:v3\/(?<azdo_org>[\w.\- %20]+)\/(?<azdo_project>[\w.\- %20]+)\/(?<azdo_repo>[\w.\- %20]+)" -- $url)

        if test $status -eq 0
            # Set the matched groups in parent scope
            set -g azdo_org $matches[2]
            set -g azdo_project $matches[3]
            set -g azdo_repo $matches[4]

            if test "$DEBUG" = 1
                echo -e (set_color '#666')"[DEBUG::regexp::ssh]"(set_color normal) (set_color yellow)"\$azdo_org"(set_color normal)":" (set_color green)"\"$azdo_org\""(set_color normal)
                echo -e (set_color '#666')"[DEBUG::regexp::ssh]"(set_color normal) (set_color yellow)"\$azdo_project"(set_color normal)":" (set_color green)"\"$azdo_project\""(set_color normal)
                echo -e (set_color '#666')"[DEBUG::regex::ssh]"(set_color normal) (set_color yellow)"\$azdo_repo"(set_color normal)":" (set_color green)"\"$azdo_repo\""(set_color normal)
                echo ""
            end

            return 0
        end

        return 2
    end

    # Default values for function arguments
    set -l _flag_source_branch (fallback $AZURE_DEVOPS_FISH_SOURCE_BRANCH (git branch --show-current))
    set -l _flag_target_branch (fallback $AZURE_DEVOPS_FISH_TARGET_BRANCH (git config --get init.defaultBranch) "main")
    set -l _flag_git_remote (fallback $AZURE_DEVOPS_FISH_GIT_REMOTE "origin")

    # Parse function arguments
    argparse "h/help=?" "r/git-remote=" "R/git-remote-url=" "s/source-branch=" "t/target-branch=" -- $argv; or return

    if test "$DEBUG" = 1
        echo ""
        echo -e (set_color '#666')"[DEBUG::argument]"(set_color normal) (set_color yellow)"\$_flag_source_branch"(set_color normal)":" (set_color green)"\"$_flag_source_branch\""(set_color normal)
        echo -e (set_color '#666')"[DEBUG::argument]"(set_color normal) (set_color yellow)"\$_flag_target_branch"(set_color normal)":" (set_color green)"\"$_flag_target_branch\""(set_color normal)
        echo -e (set_color '#666')"[DEBUG::argument]"(set_color normal) (set_color yellow)"\$_flag_git_remote"(set_color normal)":" (set_color green)"\"$_flag_git_remote\""(set_color normal)
    end

    if set -ql _flag_git_remote
        git remote get-url $_flag_git_remote >/dev/null 2>&1

        if test $status -ne 0
            echo ""
            echo -e (set_color red)"Invalid"(set_color normal) (set_color green)"\"$_flag_git_remote\""(set_color normal) (set_color red)"git remote"(set_color normal)
            echo -e (set_color red)"Please specify valid git remote via"(set_color normal) (set_color cyan)"azure-devops.pr-url"(set_color normal) (set_color '#AAA')"[-r|--git-remote]"(set_color normal) (set_color green)"\"<remote-name>\""(set_color normal)
            echo ""
            echo -e "\$" (set_color cyan)"azure-devops.pr-url"(set_color normal) (set_color '#AAA')"-r"(set_color normal) (set_color green)"\"upstream\""(set_color normal)
            echo ""

            echo -e "Available git remotes:"
            set_color green
            git remote
            set_color normal

            return 2
        end

        if not set -ql _flag_git_remote_url
            set _flag_git_remote_url (fallback $AZURE_DEVOPS_FISH_GIT_REMOTE_URL (git remote get-url $_flag_git_remote))
        end

        if test "$DEBUG" = 1
            echo -e (set_color '#666')"[DEBUG::arg]"(set_color normal) (set_color yellow)"\$_flag_git_remote_url"(set_color normal)":" (set_color green)"\"$_flag_git_remote_url\""(set_color normal)
            echo ""
        end
    end

    if set -ql _flag_help
        echo -e ""
        echo -e (set_color cyan)"azure-devops.pr-url"(set_color normal) (set_color BBB)"[OPTIONS]"(set_color normal)
        echo -e ""
        echo -e "Create Azure DevOps Pull Request URL"
        echo -e ""

        echo -e "Options:"
        echo -e ""

        echo -e (set_color '#AAA')"-h"(set_color normal) or (set_color '#AAA')"--help"(set_color normal) "- Show this help message"
        echo -e "    required: false"
        echo -e ""

        echo -e (set_color '#AAA')"-r"(set_color normal) or (set_color '#AAA')"--git-remote"(set_color normal) "- Azure DevOps git remote name"
        echo -e "    e.g:" (set_color green)"\"origin\""(set_color normal) or (set_color green)"\"upstream\""(set_color normal)
        echo -e "         Get available remote options from" "\""(set_color cyan)"git"(set_color normal) "remote\" command"
        echo -e ""
        echo -e "    required: false"
        echo -e "    default:" (set_color yellow)"\$AZURE_DEVOPS_FISH_GIT_REMOTE"(set_color normal) or (set_color green)"\"origin\""(set_color normal)
        echo -e ""

        echo -e (set_color '#AAA')"-R"(set_color normal) or (set_color '#AAA')"--git-remote-url"(set_color normal) "- Azure DevOps git remote URL."
        echo -e "    e.g:" (set_color --underline green)"\"https://dev.azure.com/<organization_name>/<project_name>/_git/<repository_name>"(set_color normal)
        echo -e "    required: false"
        echo -e "    default:" (set_color yellow)"\$AZURE_DEVOPS_FISH_GIT_REMOTE_URL"(set_color normal) or "\""(set_color cyan)"git"(set_color normal) "remote get-url origin\""
        echo -e ""

        echo -e (set_color '#AAA')"-s"(set_color normal) or (set_color '#AAA')"--source-branch"(set_color normal) "- Azure DevOps pull request source branch name."
        echo -e "    e.g:" (set_color green)"\"feature/my-awesome-feature\""(set_color normal)
        echo -e "    required: false"
        echo -e "    default:" (set_color yellow)"\$AZURE_DEVOPS_FISH_SOURCE_BRANCH"(set_color normal) or "\""(set_color cyan)"git"(set_color normal) branch (set_color '#AAA')"--show-current"(set_color normal)"\""
        echo -e ""

        echo -e "$(set_color '#AAA')-t$(set_color normal) or $(set_color '#AAA')--target-branch$(set_color normal) - Azure DevOps pull request target branch name."
        echo -e "    e.g: main"
        echo -e "    required: false"
        echo -e "    default:" "\""(set_color cyan)"git"(set_color normal) config (set_color '#AAA')"--get"(set_color normal) "init.defaultBranch\""
        echo -e ""

        echo -e ""

        echo -e "Example:"
        echo -e ""
        echo -e (set_color cyan)"azure-devops.pr-url"(set_color normal) (set_color '#AAA')"-s"(set_color normal) (set_color green)"\"feature/my-awesome-feature\""(set_color normal) (set_color '#AAA')"-t"(set_color normal) (set_color green)"\"main\""(set_color normal) (set_color '#AAA')"-R"(set_color normal) (set_color green)"\"https://dev.azure.com/TestOrg/Test_Project/_git/Test.Repo\""(set_color normal)
        echo -e (set_color cyan)"azure-devops.pr-url"(set_color normal) (set_color '#AAA')"-t"(set_color normal) (set_color green)"\"preprod\""(set_color normal)
        echo -e (set_color cyan)"azure-devops.pr-url"(set_color normal) (set_color '#AAA')"-t"(set_color normal) (set_color green)"\"test\""(set_color normal) (set_color '#AAA')"-r"(set_color normal) (set_color green)"\"upstream\""(set_color normal)
        return 0
    else if set -ql _flag_git_remote_url
        azure_devops_remote_url_match $_flag_git_remote_url

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

        set -g AZURE_DEVOPS_FISH_PULL_REQUEST_URL "https://dev.azure.com/$azdo_org/$azdo_project/_git/$azdo_repo/pullrequestcreate?sourceRef=$_flag_source_branch&targetRef=$_flag_target_branch"
    end

    echo "$AZURE_DEVOPS_FISH_PULL_REQUEST_URL"
end
