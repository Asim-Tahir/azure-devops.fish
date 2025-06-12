function _azure-devops.util.remote-url-match -d "Parse given Azure DevOps remote URL" -a url
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