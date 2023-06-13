#!/usr/bin/env bash
##------------------------------------
# Build util script for delta deployment
#  feb-2023,  mchinnappan
##------------------------------------

##--- logic ----

# - 1. check for the demo events, if there is a demo going on, stop the deployment
# - 2. Perform PMD scan
# - 3. Install the plugins
# - 4. Login using the jwt
# - 5. Prepare for Delta deployment
# - 6. Deplyment
##---------------------

#----- GLOBAls
_PREFIX='===='

MOHANC_PLUGIN_VERSION="0.0.350"

#----- PMD variables ----
#----- configure the following to meet your needs ----
#------ Refer: https://github.com/mohan-chinnappan-n/cli-dx/blob/master/mdapi/pmd-codescan.md ----
RULESET="./pmd/apex_ruleset.xml"
THRESHOLD=3
#PMD_PATH="codeQuality/pmd/pmd-bin-6.47.0/bin"
PMD_PATH="./pmd/pmd-bin-6.54.0/bin"
#PMD_OUTPUT=${PMD_PATH}/results.csv
PMD_OUTPUT=/tmp/results.csv

#----- delta deployment variables ----
DELTA_IGNORE_FILE="./delta/ignore.txt"
DELTA_OUT_FILE="/tmp/delta_out.json"

#------------------------------------
#  util print message funtion
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

 

function get_os_type() {
    echo $(uname)
}

#------------------------------------
#   convert time to utc seconds
# .    Darwin and Linux supported
#-----------------------------------

function to_utc_seconds() {
    local in_time="$1"

    # date -j -f "%Y-%m-%d %H:%M:%S" "2022-8-24 18:00:00" "+%s"
    # 1661378400
    if ((get_os_type == "Darwin")); then
        echo $(date -j -f "%Y-%m-%d %H:%M:%S" "$in_time" "+%s")
    else
        echo $(date -d "$in_time" +%s)
    fi

}


INSTALLED_DELTA_PLUGINS='N'
INSTALLED_FULL_PLUGINS='N'

#-------------------------
# Install required plugins
#-------------------------

install_plugins_delta() {
    if [[ $INSTALLED_DELTA_PLUGINS = 'N' ]]; then
        print_info "Installing plugins..." 
        echo 'y' | sfdx plugins:install sfdx-mohanc-plugins@${MOHANC_PLUGIN_VERSION}
        echo 'y' | sfdx plugins:install sfdx-git-delta
        INSTALLED_DELTA_PLUGINS='Y'

    else
        print_info "install_plugins_delta already done!"
    fi

}

install_plugins_full() {
    if [[ $INSTALLED_FULL_PLUGINS = 'N' ]]; then
        print_info "Installing plugins..." 
        echo 'y' | sfdx plugins:install sfdx-mohanc-plugins@${MOHANC_PLUGIN_VERSION}
        INSTALLED_FULL_PLUGINS='Y'
     else
       print_info "install_plugins_full already done!"
    fi
}

#install_plugins




#------------------------------------
#  login using jwt
#------------------------------------

login_using_jwt() {
    print_info "Trying to login using JWT ..."
    local user="$1"  
    local server_key="$2" 
    local client_id="$3" 
    sfdx force:auth:jwt:grant --username ${user} -f ${server_key} -i ${client_id}
    return "$?"

}



#------------------------------------
#   handle PMD scan errors
#-----------------------------------

function handle_pmd_errors() {
  local OUTFILE_JSON='/tmp/out.json'
    rm -f ${OUTFILE_JSON}
    rm -f /tmp/q.sql

    # query the results using SQL
    echo "SELECT COUNT(*) AS CNT   FROM CSV(\"${PMD_OUTPUT}\", {headers:true}) WHERE Priority < ${THRESHOLD}" >/tmp/q.sql
    cat /tmp/q.sql
    sfdx mohanc:data:query:sql -q /tmp/q.sql > ${OUTFILE_JSON}
    cat  ${OUTFILE_JSON}
    # check for the errors
    nerrors=$(jq '.[].CNT'  ${OUTFILE_JSON} )
    print_msg "nerrors: $nerrors"

    if [ "$nerrors" != 0 ]; then
        print_err  "Number of PMD Scan issues: which are upto: $((THRESHOLD - 1)):  $nerrors. Stopping the deployment!"

        return $nerrors
    else
        return 0
    fi

}

#------------------------------------
#   perform PMD scan
#-----------------------------------

function pmd_scan() {
    local CODE=$1

    print_msg "ApexCodePath for PMD Scan: $CODE"
    rm -f ${PMD_OUTPUT} 
    
    echo  "${PMD_PATH}/run.sh pmd -R $RULESET -d ${CODE} -f csv >${PMD_OUTPUT}"
    ${PMD_PATH}/run.sh pmd -R $RULESET -d "${CODE}" -f csv >${PMD_OUTPUT}
    cat ${PMD_OUTPUT}
    nerrors=$(wc -l ${PMD_OUTPUT})
    
    if [[ $nerrors != 0 ]]; then
        print_msg "PMD Errors output line count: $nerrors"
        if handle_pmd_errors; then
            print_info "No PMD errors, continuing the deployment..."
            return 0
        else
            print_err "PMD has errors!, can't continue!"
            return 1
        fi
    fi

}

#------------ test run --------
# pmd_scan '/Users/mchinnappan/treeprj/force-app/main/default/classes'
#------------------------------




#------------------------------------
#  check for any demo is scheduled
# demo file:
#2023-03-13 16:00:00
#2023-04-06 16:30:00
#-----------------------------------

function check_for_demo() {
    local demo_file=$1
    local os_type=$2

    print_msg "Demo file: $demo_file"

    if [ -z ${demo_file} ]; then
        print_info "File: ${demo_file}  does not exist. By passing demo check... "
        return 0
    fi

    # cat ${demo_file}
     #get the current date/time in seconds (epoch time)
    currTime=$(date -u "+%s")
    print_msg "currtime ${currTime}"
    
    while read demo; do
        print_msg "demo: $demo $os_type"

        # convert the utc demo time into seconds (epoch time)
        demoTime=$(to_utc_seconds "$demo")
        print_msg "demoTime: ${demoTime}"

        # find the difference in times
        timeDiff="$((currTime - demoTime))"
        print_msg "timeDiff: ${timeDiff}"

        if [[ $timeDiff -lt 0 ]]; then
            print_err "The deployments are blocked until UTC: $demo"
            exit 1
        fi

    done <$demo_file

    print_info "No Demo request found, continue the deployment"


}


#------------ test run --------
# check_for_demo "/tmp/demo1.txt"
#------------------------------



#------------------
# validation_check()

# validation file format:
# Date|User Story Number|Branch|Validation|PMD|Apex Class Comments|*Deployment* Confirmation in STNR3|*Deployment* Confirmation in SITNR3
# 04/21/23|SFDCJ-26902|SFDCJ-26902_5|true|true|true|false|false
#------------------

validation_check() {
    local validation_file="$1"
    local FIELD_DELIMITER='|' # Pipe Separaate file

    #check to make sure all the recent PRS were validated against the org
    while IFS= read -r line; do
            
            # read each line of the PSV file 
            IFS=${FIELD_DELIMITER}
            read -ra item <<<"$line"
            
            # break the line up into fields
            PR=${item[1]}
            PMD=${item[4]}
            ApexComments=${item[5]}
            Validated=${item[3]}
            Deployed1=${item[6]}
            Deployed2=${item[7]}

            if [[ -z "$PR" ]]; then
                echo "There is nothing to push, exiting..."
                exit 2
            fi

            # check if the user story has been validated. If it has, perform the release
            if [ $Validated = 'true' ] && [ $PMD = 'true' ] && [ $ApexComments = 'true' ] && [ $Deployed1 = 'false' ]; then
                echo "Pull Request $PR has been validated, it will be queued for release ..."

            elif [ $Validated = 'false' ] || [ $PMD = 'false' ] || [ $ApexComments = 'false' ]; then
                # if any pr has not been validated, then we stop the entire script
                echo "Cannot Run Release, Pull Request Number $PR Has Not Yet Been Validated. Please check that PMD validation, deployment validation, and Code Comments have been added to this PR ..."
                exit 2
            fi
    done < <(tail -n 20  ${validation_file})
}

#------------ test run --------
# validation_check ' /tmp/codeValidtion.psv'
#------------ test run --------



#------------------------------------
#  prepre for delta deployment
#-----------------------------------

function prep_delta_deploy() {
    local from=$1
    local to=$2
    local ignoreFile=${3:-'NONE'}
    local outfile='/tmp/delta.json'

    local ignoreFileFlag=''

    if [ ${ignoreFile} = 'NONE' ]; then
        ignoreFileFlag=''
    else
        ignoreFileFlag="-i ${ignoreFile}"
    fi

    print_msg "running: sfdx sgd:source:delta -f $from -t $to  ${ignoreFileFlag} -o .  > ${outfile}"
    sfdx sgd:source:delta -f $from -t $to ${ignoreFileFlag} -o . >${outfile}
    print_msg "Exit status: $? "
    cat ${outfile}
    prep_detla_deploy_status_success=$(jq '.success'  ${outfile})
    if [ "$prep_detla_deploy_status_success" == "true" ]; then
        print_msg "Delta deployment prep is success, continuing the deployment..."

        print_info "-------------------------------"
        print_info "package/package.xml"
        cat package/package.xml
        print_info "-------------------------------"
        print_info "destructiveChanges/destructiveChanges.xml"
        cat destructiveChanges/destructiveChanges.xml
        return 0
    else
        print_msg "Delta deployment prep failed!"
        cat ${outfile}
        return 1
    fi

}

#---------test---------------

# prep_delta_deploy HEAD~4 HEAD
#----------------------------






#------------------------------------
#   main driver function for build
#-----------------------------------
#-------- delta build ------

function build_delta() {

    local branch=$1 #GIT_BRANCH
    local from=$2   #GIT_PREVIOUS_SUCCESSFUL_COMMIT
    local to=$3     #$(git rev-parse $branch)
    local un=$4
    local demo_file=$5
    local apexClassPath=${6:-'NONE'}
    local preOrPost=${7:-'post'}
    local RT=${8:-' '} # ' --testlevel RunLocalTests  '
    local checkOnly=${9:-' '}
    DELTA_IGNORE_FILE=${10:-'NONE'}

    local os_type=$(get_os_type)

    print_msg "OS Type: $os_type"

    print_msg "Inputs:"

    print_msg "branch: ${branch}"
    print_msg "from SHA1: ${from}"
    print_msg "to SHA1: ${to}"
    print_msg "username: ${un}"

    print_msg "demo_file: ${demo_file}"
    print_msg "run test class: ${RT}"
    print_msg "preOrPost: ${preOrPost}"
    print_msg "checkOnly: ${checkOnly}"
    print_msg "deltaIgnoreFile: ${DELTA_IGNORE_FILE}"

    print_msg "================="

    #check if there is even anything to push to the orgs
    if [[ "$to" == "$from" ]]; then
        echo "There are no delta changes to commit, exiting..."
        exit 1
    fi

    print_msg "demo file:  $demo_file"

    #----- by passing demo if it is 'NONE'
    if [ "${demo_file}" = "NONE" ]; then
        print_msg " By passing demo check... "
    else
        if check_for_demo "$demo_file" "$os_type"; then
            print_msg "Going to deploy..."
        else
            print_msg "Deployment is blocked due to demo schedule"
        fi
    fi

    #--- PMD
    if [ "${apexClassPath}" = "NONE" ]; then
        print_msg " By passing PMD scan..."
    else
        if pmd_scan "${apexClassPath}" ; then
            print_msg "After PMD Scan, Continuing the deployment..."
        else
            print_msg "After PMD Scan, Stopping the deployment..."
            return 1
        fi
    fi

    #--- delta deployment prep
    if prep_delta_deploy $from $to "${DELTA_IGNORE_FILE}" "${DELTA_OUT_FILE}"; then
        print_msg "After delta deployment prep, Continuing the deployment..."
    else
        print_msg "After delta deployment prep errors, Stopping the deployment..."
        return 1
    fi
    
    if [[ "$preOrPost" == "NONE" ]]; then 
    #--- now deploy
    print_msg "sfdx force:source:deploy -x package/package.xml -u ${un}   --json ${checkOnly}  --verbose --loglevel TRACE ${RT}  > /tmp/deploy_status.json "
               sfdx force:source:deploy -x package/package.xml -u ${un}   --json ${checkOnly}  --verbose --loglevel TRACE ${RT} > /tmp/deploy_status.json 
    else 
    #--- now deploy
    print_msg "sfdx force:source:deploy -x package/package.xml -u ${un} --${preOrPost}destructivechanges destructiveChanges/destructiveChanges.xml  --json ${checkOnly}  --verbose --loglevel TRACE ${RT}  > /tmp/deploy_status.json "
               sfdx force:source:deploy -x package/package.xml -u ${un} --${preOrPost}destructivechanges destructiveChanges/destructiveChanges.xml  --json ${checkOnly}  --verbose --loglevel TRACE ${RT} > /tmp/deploy_status.json 
    
    fi

    exit_status=$?
    print_msg "exit status: ${exit_status}"
    cat /tmp/deploy_status.json  

     if [ "$exit_status" == 0 ]; then
        print_info "delta deploy  success! Continue..."
    else
        print_err "delta deploy  Failed!"
        exit 2
    fi


    #if ((get_os_type == "Darwin")); then
    #    jq  '.result.details.componentSuccesses' /tmp/deploy_status.json| pbcopy ; open "https://mohan-chinnappan-n5.github.io/viz/datatable/dt.html?c=json"
    #    jq  '.result.details.componentFailures'  /tmp/deploy_status.json| pbcopy ; open "https://mohan-chinnappan-n5.github.io/viz/datatable/dt.html?c=json"
    #fi
    return  "$?"

}

#--------------test-------------
#login_using_jwt mohan.chinnappan.n.sel@gmail.com /Users/mchinnappan/jwt/server.key '3MVG9kBt168mda_.dKX627bLPDHTSzraOTJVIBxNFOOhGbhRFgaNWG2bFQdgD.IPFMmAu7rsF912IcK4HSdIh'
#if [ "$?" == 0 ]; then
#    print_info "Login success! Continue..."
#else
#    print_err "Login Failed!"
#    exit 2
#fi
# build_delta 'patch1' HEAD~4 HEAD 'mohan.chinnappan.n.sel@gmail.com' '/tmp/demo1.txt' '/Users/mchinnappan/treeprj/force-app/main/default/classes' 'post'  ' --testlevel RunLocalTests '
# build_full ${uns[$index]} ${srcFolder}   ${demoFile} "${apexClassPath}" "${prePost}" "${RT}" "${VALIDATE}"
#-------- complete full build ------
function build_full() {
    local un=$1
    local srcFolder=$2
    local demo_file=$3
    local apexClassPath=$4

    local RT=$5
    local checkOnly=$6

    local os_type=$(get_os_type)

    print_msg "OS Type: $os_type"

    print_msg "Inputs:"

    print_msg "username: ${un}"
    print_msg "srcFolder: ${srcFolder}"
    print_msg "demo_file: ${demo_file}"
    print_msg "run test class: ${RT}"
    print_msg "checkOnly: ${checkOnly}"
    print_msg "apexClassPath: ${apexClassPath}"

    print_msg "================="

    #----- by passing demo if it is 'NONE'
    if [ "${demo_file}" = "NONE" ]; then
        print_msg " By passing demo check... "
    else
        if check_for_demo "$demo_file" "$os_type"; then
            print_msg "Going to deploy..."
        else
            print_msg "Deployment is blocked due to demo schedule"
            exit 2
        fi
    fi

    #--- PMD
    if [ "${apexClassPath}" = "NONE" ]; then
        print_msg " By passing PMD scan..."
    else
        if pmd_scan "${apexClassPath}" ; then
            print_msg "After PMD Scan, Continuing the deployment..."
        else
            print_msg "After PMD Scan, Stopping the deployment..."
            return 1
        fi
    fi
    #--- now deploy

    print_msg "sfdx force:source:deploy -p  ${srcFolder} -u ${un}  ${RT}  --json ${checkOnly}   --verbose --loglevel TRACE > /tmp/deploy_status.json " 
               sfdx force:source:deploy -p  ${srcFolder} -u ${un}  ${RT}  --json ${checkOnly}   --verbose --loglevel TRACE 
    exit_status=$?
    print_msg "exit status: ${exit_status}"
    # cat /tmp/deploy_status.json  

     if [ "$exit_status" == 0 ]; then
        print_info "full deploy  success! Continue..."
    else
        print_err "full deploy  Failed!"
        exit 2
    fi


}
