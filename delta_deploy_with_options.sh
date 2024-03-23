# Function to deploy with pre, post, or none option
# Author: Mohan Chinnappan
#----------------------------------------------------

# Function: deploy_with_option
#
# Description:
#   This function deploys Salesforce source code with the appropriate pre, post, or none option based on the contents of the provided destructiveChanges.xml file.
#
# Arguments:
#   $1 (string): Path to the destructiveChanges.xml file.
#   $2 (string): Path to the package.xml file.
#   $3 (integer): Expected line count in the destructiveChanges.xml file to determine the deployment action.
#
# Returns:
#   None
#
# Dependencies:
#   This function assumes that the Salesforce CLI (sfdx) is installed and configured properly.
#
# Example usage:
#   deploy_with_option "destructiveChanges/destructiveChanges.xml" "package/package.xml" 4
#
# Notes:
#   - The function calculates the line count of the destructiveChanges.xml file and compares it with the provided line count argument.
#   - If the line count matches the argument, the function deploys without any pre/post option (-g).
#   - If the line count does not match, the function attempts deployment with the pre option first. If that fails, it tries deployment with the post option.
#   - Deployment status and output are logged to /tmp/deploy_status.json.
#   - If the deployment is successful, the function prints a success message and continues. Otherwise, it prints an error message and exits with code 2.

deploy_with_option() {
    local exit_status
    local preOrPost
    local destructive_changes_file="$1"
    local package_file="$2"
    local line_count_arg="$3"
    local line_count=$(sed '/^\s*$/d' "$destructive_changes_file" | wc -l | xargs)

    if [ "$line_count" -eq "$line_count_arg" ]; then
        print_msg "No pre/post action required. Deploying without pre/post option..."
        sfdx force:source:deploy -g -x "$package_file" -u ${un} --json ${checkOnly} --verbose --loglevel TRACE ${RT} > /tmp/deploy_status.json
        exit_status=$?
    else
        # Deploy with pre option
        print_msg "Deploying with pre option..."
        sfdx force:source:deploy -g -x "$package_file" -u ${un} --predestructivechanges "$destructive_changes_file" --json ${checkOnly} --verbose --loglevel TRACE ${RT} > /tmp/deploy_status.json
        exit_status=$?

        if [ "$exit_status" -ne 0 ]; then
            # Deploy with post option
            print_msg "Deploying with post option..."
            sfdx force:source:deploy -g -x "$package_file" -u ${un} --postdestructivechanges "$destructive_changes_file" --json ${checkOnly} --verbose --loglevel TRACE ${RT} > /tmp/deploy_status.json
            exit_status=$?
        fi
    fi

    print_msg "Exit status: ${exit_status}"
    cat /tmp/deploy_status.json  

    if [ "$exit_status" -eq 0 ]; then
        print_info "Delta deploy success! Continuing..."
    else
        print_err "Delta deploy failed!"
        exit 2
    fi
}

# Call the function with the line count as an argument
# deploy_with_option "destructiveChanges/destructiveChanges.xml" "package/package.xml" 4
