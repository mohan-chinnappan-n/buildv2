
#-----------------------------------
function print_msg() {
    local msg=$1
    echo -e "\033[34m$_PREFIX $msg $_PREFIX\033[0m"
}

function print_err() {
    local msg=$1
    echo -e "\033[31m$_PREFIX $msg $_PREFIX\033[0m"
}

function print_info() {
    local msg=$1
    echo -e "\033[32m$_PREFIX $msg $_PREFIX\033[0m"

}


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

# Function to deploy with pre, post, or none option
# Function to deploy with pre, post, or none option


#######################################################################################################
# Function: deploy_with_option
#
# Description:
#   This function deploys Salesforce source code with the appropriate pre, post, or none option based on
#   the contents of the provided destructiveChanges.xml file.
#
# Arguments:
#   $1 (string): Path to the destructiveChanges.xml file.
#   $2 (string): Path to the package.xml file.
#   $3 (integer): Expected line count in the destructiveChanges.xml file to determine the deployment action.
#   $4 (string): Option to specify whether to use pre, post, or none for deployment.
#   $5 (string): Username or alias for the target Salesforce org.
#   $6 (string): Flag indicating whether to run deployment in check only mode.
#   $7 (string): Additional deployment options. RT - run test classes
#
# Returns:
#   None
#
# Dependencies:
#   This function assumes that the Salesforce CLI (sfdx) is installed and configured properly.
#
# Example usage:
#   deploy_with_option "destructiveChanges/destructiveChanges.xml" "package/package.xml" 4 "pre" "username@example.com" "-c" " "
#
# Notes:
#   - The function calculates the line count of the destructiveChanges.xml file and compares it with the
#     provided line count argument.
#   - If the line count matches the argument, the function deploys without any pre/post option (-g).
#   - If the line count does not match, the function attempts deployment with the pre option first. If that
#     fails, it tries deployment with the post option.
#   - Deployment status and output are logged to /tmp/deploy_status.json.
#   - If the deployment is successful, the function prints a success message and continues. Otherwise, it
#     prints an error message and exits with code 2.
#######################################################################################################

# Function to deploy with pre, post, or none option
deploy_with_option() {
    local exit_status
    local preOrPost="$4"
    local destructive_changes_file="$1"
    local package_file="$2"
    local line_count_arg="$3"
    local un=$5
    local checkOnly=$6
    local RT=$7
    local line_count=$(sed '/^\s*$/d' "$destructive_changes_file" | wc -l | xargs)

    if [ "$preOrPost" == "NONE" ]; then
        print_msg "No need for destructive changes. Deploying without pre/post option..."
        print_msg "sfdx force:source:deploy -x \"$package_file\" -u $un --json $checkOnly --verbose --loglevel TRACE $RT > /tmp/deploy_status.json"
        sfdx force:source:deploy -x "$package_file" -u "$un" --json "$checkOnly" --verbose --loglevel TRACE "$RT" > /tmp/deploy_status.json
        exit_status=$?
    else
        if [ "$line_count" -eq "$line_count_arg" ]; then
            print_msg "No pre/post action required. Deploying without pre/post option..."
            print_msg "sfdx force:source:deploy  -x \"$package_file\" -u $un --json $checkOnly --verbose --loglevel TRACE $RT > /tmp/deploy_status.json"
            sfdx force:source:deploy  -x "$package_file" -u "$un" --json "$checkOnly" --verbose --loglevel TRACE "$RT" > /tmp/deploy_status.json
            exit_status=$?
        else
            # Deploy with pre option
            print_msg "Deploying with pre option..."
            print_msg "sfdx force:source:deploy -g -x \"$package_file\" -u $un --predestructivechanges \"$destructive_changes_file\" --json $checkOnly --verbose --loglevel TRACE $RT > /tmp/deploy_status.json"
            sfdx force:source:deploy -g -x "$package_file" -u "$un" --predestructivechanges "$destructive_changes_file" --json "$checkOnly" --verbose --loglevel TRACE "$RT" > /tmp/deploy_status.json
            exit_status=$?

            if [ "$exit_status" -ne 0 ]; then
                # Deploy with post option
                print_msg "Deploying with post option..."
                print_msg "sfdx force:source:deploy -g -x \"$package_file\" -u $un --postdestructivechanges \"$destructive_changes_file\" --json $checkOnly --verbose --loglevel TRACE $RT > /tmp/deploy_status.json"
                sfdx force:source:deploy -g -x "$package_file" -u "$un" --postdestructivechanges "$destructive_changes_file" --json "$checkOnly" --verbose --loglevel TRACE "$RT" > /tmp/deploy_status.json
                exit_status=$?
            else
                print_msg "Could not do pre/post action. Deploying without pre/post option..."
                print_msg "sfdx force:source:deploy  -x \"$package_file\" -u $un --json $checkOnly --verbose --loglevel TRACE $RT > /tmp/deploy_status.json"
                sfdx force:source:deploy  -x "$package_file" -u "$un" --json "$checkOnly" --verbose --loglevel TRACE "$RT" > /tmp/deploy_status.json
                exit_status=$?
            fi
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

# deploy_with_option  ~/tmp/builds/dpkg.xml ~/tmp/builds/pkg.xml 4 NONE mohan@org.com "-c"  ""
deploy_with_option  ~/tmp/builds/dpkg.xml ~/tmp/builds/pkg.xml 4 NOTNONE mohan@org.com "-c"  ""