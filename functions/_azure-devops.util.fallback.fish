function _azure-devops.util.fallback -d "Fallback to first non-empty argument"
    for value in $argv
        if test "$value" != ""
            echo $value
            break
        end
    end
end