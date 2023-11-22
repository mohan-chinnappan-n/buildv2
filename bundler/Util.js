// Util.js
// mohan chinnappan
export class Util {
  static pathJoin(parts, sep) {
    var separator = sep || "/";
    var replace = new RegExp(separator + "{1,}", "g");
    return parts.join(separator).replace(replace, separator);
  }

  static getForceIgnore () {
    const content =
`package.xml
src-env-specific-alias-post/**
src-env-specific-alias-pre/**
src-env-specific-pre/**
src-env-specific/**
src-ui/README.md
src-env-specific-alias-post/README.md
src-env-specific-pre/README.md
src/core-crm/README.md
src-temp/README.md
**/README.md
**/.DS_Store
**/*.md
**appMenu
**appSwitcher
**objectTranslations
artifacts
# LWC configuration files
**/jsconfig.json
**/.eslintrc.json
# LWC Jest
**/__tests__/**
# LWC Jest
**/lwc/__mocks__/**


`
return content;
  }
  static generateCopyScript(
    sourceDir,
    destinationDir,
    typeAndMembers,
    typeInfoMap,
    summary
  ) {
    const scriptLines = []; 

    let subFolder = "force-app/main/default";
    
    // Create the destination directory if it doesn't exist
    //scriptLines.push(`mkdir -p "${destinationDir}/${subFolder}"`);

    // Loop through the type and members and construct source and target paths
    typeAndMembers.forEach(({ type, members }) => {
      scriptLines.push(`echo "--------------------------------------------"`);
      if (typeInfoMap[type] === null) {
        throw new Error(`--- ${type} has no typeInfoMap! Can't continue... ---`);
        // console.err(`*** ${type} has no typeInfoMap! ***`);
      }

      // Determine the folder name, file name, and file extension based on the type
      const typeInfo = typeInfoMap[type] ;

    

      scriptLines.push(`echo "_____ ${type} : ${members.length} _____"`);
      summary.push(`${type} (${members.length})`);

      // Create the destination directory if it doesn't exist
      // scriptLines.push(`mkdir -p "${destinationDir}/${subFolder}/${typeInfo.folderName}"`);

      let sourcePaths = [], destinationPaths = [];

       let ndx = 0;
       for (const member of members) {
        if (ndx === 1 && typeInfo.once) break;
        ndx++;

      //members.forEach((member, ndx) => {
        scriptLines.push(`echo "======= member: ${member} ======="`);

        try {

         if (!typeInfo) {
            // alert (`Do not know about the type : ${type}! Can't continue...`);
            throw new Error(`--- ${type} has no typeInfoMap! Can't continue... ---`);
            return;
          } 

        if (typeInfo.getFileAttributes(member)) {
          const { folderName, fileNames } = typeInfo.getFileAttributes(member);
          for (const fileName of fileNames) {
          //fileNames.forEach((fileName) => {
            sourcePaths.push(
              this.pathJoin([sourceDir, folderName, fileName])
            );
            destinationPaths.push(
              this.pathJoin([destinationDir, subFolder, folderName, fileName])
            );
            scriptLines.push( `mkdir -p "${destinationDir}/${subFolder}/${folderName}"`);
          };
        } else {
           
          sourcePaths.push(
            this.pathJoin([
              sourceDir,
              typeInfo.folderName,
              member + typeInfo.fileExtension,
            ])
          );
          destinationPaths.push(
            this.pathJoin([
              destinationDir,
              subFolder,
              typeInfo.folderName,
              member + typeInfo.fileExtension,
            ])
          );
        }
      }
      catch(e){
        alert (e);

      }

 
      
      };
      sourcePaths.forEach((sourcePath, index) => {
        // Check if we should copy all files within a LightningComponentBundle
        if (typeInfo.copyAllFiles) {
          // console.log(typeInfo)
          scriptLines.push(
            `cp -r  "${sourcePath}" "${destinationPaths[index]}"`
          );
        } else {
          scriptLines.push(`cp "${sourcePath}" "${destinationPaths[index]}"`);
        }
      });
    });

    return scriptLines.join("\n");
  }
  static copyPkgXmls(templateName, packageXmlPath,destructiveXmlPath) {
    const getForceIgnore = this.getForceIgnore();
    return `

echo "---- Creating sfdx project for ${templateName}... ----"
rm -fr ${templateName}; sfdx force:project:create -n ${templateName}

cat << EOF  >  ${templateName}/.forceignore 
${getForceIgnore} 
EOF


echo "---- copying package.xml and destructiveChanges.xml to ${templateName} folder ... ----"
cp ${packageXmlPath} ${templateName}
cp ${destructiveXmlPath} ${templateName} 

echo 'sfdx force:source:deploy -x package.xml  --\${2}destructivechanges destructiveChanges.xml --verbose --testlevel RunLocalTests  -c -u \${1}' > ${templateName}/deploy.sh
 `
  }

  static getZipper( templateName) {
    return `
zip -r ${templateName}.zip ${templateName}/*   ${templateName}/.forceignore
    `;
  }

  static getReadme(templateName, testClassList, userName) {
   const output = 
`
# Steps to deploy this package
   
Make sure the deploying user has required CRMA permission sets assigned
   
[Download the zip file](\${TEMPLATE_NAME}.zip)
   
Unzip it to a folder of your choice
------------------------
unzip \${TEMPLATE_NAME}.zip 
------------------------

cd to \${TEMPLATE_NAME} folder

------------------------
cd  \${TEMPLATE_NAME} 
------------------------
   
deploy (validation)
------------------------
bash deploy.sh \${USERNAME} pre|post
------------------------
   
copy the command in the terminal and run it after you have logged into the org

------------------------
sfdx force:auth:web:login -r https://login|test.salesforce.com
------------------------


   
   
## Example:
### Run only specified classes only
------------------------
sfdx force:source:deploy -x package.xml --postdestructivechanges destructiveChanges.xml --verbose --testlevel RunSpecifiedTests -r \${TEST_CLASS_LIST} -c -u \${USERNAME}
------------------------

### Run all test classes
------------------------
sfdx force:source:deploy -x package.xml --postdestructivechanges destructiveChanges.xml --verbose --testlevel RunLocalTests  -c -u \${USERNAME}
------------------------
  
   
Note down the **Deploy ID:** for  quick deploy:
------------------------ 
sfdx force:mdapi:deploy -q <Deploy ID> -w -1 -u \${USERNAME} 
------------------------ 
`;
   return output;
   
  }

  static writeDeloysh() {
    return `
echo sfdx force:source:deploy -x package.xml  --${2}destructivechanges destructiveChanges.xml --verbose --testlevel RunLocalTests  -c -u $1
    `
  }

  static getEnvVars(templateName, fromFolder, branchName,testClassList, userName ) {

  // Store input in localStorage
  const data = { templateName, fromFolder, branchName,  testClassList, userName  };
  //console.log(data);
  localStorage.setItem('envData', JSON.stringify(data));



return `
# TEMPLATE_NAME is the your package name 
# - example: PATCH_RELEASE_22)
TEMPLATE_NAME="${templateName}"

# FROM_FOLDER is where checkout branch code lives: full path until 'default' folder
# - example: /User/DennisRitchie/ProjectX/force-app/main/default
FROM_FOLDER="${fromFolder}"

CWD=\`pwd\`
cd "${fromFolder}" 
git checkout ${branchName}
git pull
cd "\${CWD}"

TO_FOLDER="\${TEMPLATE_NAME}"
# TEST_CLASS_LIST is comma separated list of Test classes to be run for RunSpecifiedTests option
TEST_CLASS_LIST="${testClassList}"

# USERNAME is your username for the org that you are deploying to
#  - Login to the org using:  'sfdx force:auth:web:login -r https://login|test.salesforce.com'x
USERNAME="${userName}"
`
  }
}
