complete -c azure-devops.workitem-url -s h -l help -d "Show help message"
complete -c azure-devops.workitem-url -s o -l organization -d "Azure DevOps organization name"
complete -c azure-devops.workitem-url -s p -l project -d "Azure DevOps project name"
complete -c azure-devops.workitem-url -s w -l workitem -d "Azure DevOps work item ID"

function azure-devops.workitem-url -d "Get Azure DevOps Work Item URL"
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
    set -l _flag_organization (fallback $AZURE_DEVOPS_FISH_ORGANIZATION)
    set -l _flag_project (fallback $AZURE_DEVOPS_FISH_PROJECT)
    set -l _flag_workitem (fallback $AZURE_DEVOPS_FISH_WORKITEM)

    # Parse function arguments
    argparse "h/help=?" "o/organization=" "p/project=" "w/workitem=" -- $argv; or return

    if test "$DEBUG" = 1
        echo ""
        echo -e (set_color '#666')"[DEBUG::argument]"(set_color normal) (set_color yellow)"\$_flag_organization"(set_color normal)":" (set_color green)"\"$_flag_organization\""(set_color normal)
        echo -e (set_color '#666')"[DEBUG::argument]"(set_color normal) (set_color yellow)"\$_flag_project"(set_color normal)":" (set_color green)"\"$_flag_project\""(set_color normal)
        echo -e (set_color '#666')"[DEBUG::argument]"(set_color normal) (set_color yellow)"\$_flag_workitem"(set_color normal)":" (set_color green)"\"$_flag_workitem\""(set_color normal)
    end

    if set -ql _flag_help
        echo -e ""
        echo -e (set_color cyan)"azure-devops.workitem-url"(set_color normal) (set_color BBB)"[OPTIONS]"(set_color normal)
        echo -e ""
        echo -e "Get Azure DevOps Work Item URL"
        echo -e ""

        echo -e "Options:"
        echo -e ""

        echo -e (set_color '#AAA')"-h"(set_color normal) or (set_color '#AAA')"--help"(set_color normal) "- Show this help message"
        echo -e "    required: false"
        echo -e ""

        echo -e (set_color '#AAA')"-o"(set_color normal) or (set_color '#AAA')"--organization"(set_color normal) "- Azure DevOps organization name"
        echo -e "    e.g:" (set_color green)"\"MyOrganization\""(set_color normal)
        echo -e "    required: true"
        echo -e "    default:" (set_color yellow)"\$AZURE_DEVOPS_FISH_ORGANIZATION"(set_color normal)
        echo -e ""

        echo -e (set_color '#AAA')"-p"(set_color normal) or (set_color '#AAA')"--project"(set_color normal) "- Azure DevOps project name."
        echo -e "    e.g:" (set_color green)"\"MyProject\""(set_color normal)
        echo -e "    required: true"
        echo -e "    default:" (set_color yellow)"\$AZURE_DEVOPS_FISH_PROJECT"(set_color normal)
        echo -e ""

        echo -e (set_color '#AAA')"-w"(set_color normal) or (set_color '#AAA')"--workitem"(set_color normal) "- Azure DevOps work item ID."
        echo -e "    e.g:" (set_color bryellow)"12345"(set_color normal)
        echo -e "    required: true"
        echo -e "    default:" (set_color yellow)"\$AZURE_DEVOPS_FISH_WORKITEM"(set_color normal)""
        echo -e ""

        echo -e ""

        echo -e "Example:"
        echo -e ""
        echo -e (set_color cyan)"azure-devops.workitem-url"(set_color normal) (set_color '#AAA')"-o"(set_color normal) (set_color green)"\"MyOrganization\""(set_color normal) (set_color '#AAA')"-p"(set_color normal) (set_color green)"\"MyProject\""(set_color normal) (set_color '#AAA')"-w"(set_color normal) (set_color bryellow)"12345"(set_color normal)
        return 0
    end

    if set -ql _flag_organization
        if string match -rq '^[[:space:]]*$' -- $_flag_organization
            echo -e (set_color red)"Required: Organization name is required."(set_color normal)
            echo ""
            echo "Example:"
            echo ""
            echo -e (set_color cyan)"azure-devops.workitem-url"(set_color normal) (set_color '#AAA')"-o"(set_color normal) (set_color green)"\"MyOrganization\""(set_color normal)
            return 1
        end
    end

    if set -ql _flag_project
        if string match -rq '^[[:space:]]*$' -- $_flag_project
            echo -e (set_color red)"Required: Project name is required."(set_color normal)
            echo ""
            echo "Example:"
            echo ""
            echo -e (set_color cyan)"azure-devops.workitem-url"(set_color normal) (set_color '#AAA')"-p"(set_color normal) (set_color green)"\"MyProject\""(set_color normal)
            return 1
        end
    end

    if set -ql _flag_workitem
        if string match -rq '^[[:space:]]*$' -- $_flag_workitem
            echo -e (set_color red)"Required: Work item ID is required."(set_color normal)
            echo ""
            echo "Example:"
            echo ""
            echo -e (set_color cyan)"azure-devops.workitem-url"(set_color normal) (set_color '#AAA')"-w"(set_color normal) (set_color bryellow)"12345"(set_color normal)
            return 1
        else if not string match -rq '^[1-9][0-9]*$' -- $_flag_workitem
            echo ""
            echo -e (set_color red)"Invalid"(set_color normal) (set_color bryellow)"\"$_flag_workitem\""(set_color normal) (set_color red)"work item ID"(set_color normal)
            echo -e (set_color red)"Work item ID should be a positive integer."(set_color normal)

            echo ""

            echo "Example:"
            echo ""
            echo -e (set_color cyan)"azure-devops.workitem-url"(set_color normal) (set_color '#AAA')"-w"(set_color normal) (set_color bryellow)"12345"(set_color normal)
            return 1
        end
    end

    echo "https://dev.azure.com/$_flag_organization/$_flag_project/_workitems/edit/$_flag_workitem"
end
