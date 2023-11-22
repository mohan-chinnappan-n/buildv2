
// Types.js, part of bundler builder
// mohan chinnappan 
export class Types { 

// Mapping of type names to folder names and file extensions
static typeInfoMap = {
    'ApexClass': {
        folderName: 'classes',
        getFileAttributes: (member) => {
            return {
                folderName: `classes`,
                fileNames: [ `${member}.cls`, `${member}.cls-meta.xml`]
            };
        }
    },

    'ContentAsset': {
        folderName: 'contentassets',
        getFileAttributes: (member) => {
            return {
                folderName: `contentassets`,
                fileNames: [ `${member}*`]
            };
        }
    },

    'BrandingSet': {
        folderName: 'brandingSets',
        getFileAttributes: (member) => {
            return {
                folderName: `brandingSets`,
                fileNames: [ `${member}.brandingSet-meta.xml`]
            };
        }
    },



    'Flow': {
        folderName: 'flows',
        getFileAttributes: (member) => {
            return {
                folderName: `flows`,
                fileNames: [ `${member}.flow-meta.xml`]
            };
        }
    },

    'FlowDefinition': {
        folderName: 'flowDefinitions',
        getFileAttributes: (member) => {
            return {
                folderName: `flowDefinitions`,
                fileNames: [ `${member}.flowDefinition-meta.xml`]
            };
        }
    },

    'DataCategoryGroup': {
        folderName: 'datacategorygroups',
        getFileAttributes: (member) => {
            return {
                folderName: `datacategorygroups`,
                fileNames: [ `${member}.datacategorygroup-meta.xml`]
            };
        }
    },

    'DelegateGroup': {
        folderName: 'delegateGroups',
        getFileAttributes: (member) => {
            return {
                folderName: `delegateGroups`,
                fileNames: [ `${member}.delegateGroup-meta.xml`]
            };
        }
    },



    'FlexiPage': {
        folderName: 'flexipages',
        getFileAttributes: (member) => {
            return {
                folderName: `flexipages`,
                fileNames: [ `${member}.flexipage-meta.xml`]
            };
        }
    },

    'PermissionSetGroup': {
        folderName: 'permissionsetgroups',
        getFileAttributes: (member) => {
            return {
                folderName: `permissionsetgroups`,
                fileNames: [ `${member}.permissionsetgroup-meta.xml`]
            };
        }
    },


    'PermissionSet': {
        folderName: 'permissionsets',
        getFileAttributes: (member) => {
            return {
                folderName: `permissionsets`,
                fileNames: [ `${member}.permissionset-meta.xml`]
            };
        }
    },

    'Profile': {
        folderName: 'profiles',
        getFileAttributes: (member) => {
            return {
                folderName: `profiles`,
                fileNames: [ `${member}.profile-meta.xml`]
            };
        }
    },




    'PermissionSetGroup': {
        folderName: 'permissionsetgroups',
        getFileAttributes: (member) => {
            return {
                folderName: `permissionsetgroups`,
                fileNames: [ `${member}.permissionsetgroup-meta.xml`]
            };
        }
    },


    'ReportType': {
        folderName: 'reportTypes',
        getFileAttributes: (member) => {
            return {
                folderName: `reportTypes`,
                fileNames: [ `${member}.reportType-meta.xml`]
            };
        }
    },


   



    'QuickAction': {
        folderName: 'quickActions',
        getFileAttributes: (member) => {
            return {
                folderName: `quickActions`,
                fileNames: [ `${member}.quickAction-meta.xml`]
            };
        }
    },







    'CustomApplication': {
        folderName: 'applications',
        getFileAttributes: (member) => {
                return {
                    folderName: `applications`,
                    fileNames: [ `${member}.app-meta.xml`]
                };
            }
     },

     'LeadConvertSettings': {
        folderName: 'LeadConvertSettings',
        getFileAttributes: (member) => {
                return {
                    folderName: `LeadConvertSettings`,
                    fileNames: [ `${member}.LeadConvertSetting-meta.xml`]
                };
            }
     },

     'DuplicateRule': {
        folderName: 'duplicateRules',
        getFileAttributes: (member) => {
                return {
                    folderName: `duplicateRules`,
                    fileNames: [ `${member}.duplicateRule-meta.xml`]
                };
            }
     },


     'ApprovalProcess': {
        folderName: 'approvalProcesses',
        getFileAttributes: (member) => {
                return {
                    folderName: `approvalProcesses`,
                    fileNames: [ `${member}.approvalProcess-meta.xml`]
                };
            }
     },

     'AssignmentRules': {
        folderName: 'assignmentRules',
        getFileAttributes: (member) => {
                return {
                    folderName: `assignmentRules`,
                    fileNames: [ `${member}.assignmentRules-meta.xml`]
                };
            }
     },

     'Layout': {
        folderName: 'layouts',
        getFileAttributes: (member) => {
                return {
                    folderName: `layouts`,
                    fileNames: [ `${member}.layout-meta.xml`]
                };
            }
     },

     'CustomPermission': {
        folderName: 'customPermissions',
        getFileAttributes: (member) => {
                return {
                    folderName: `customPermissions`,
                    fileNames: [ `${member}.customPermission-meta.xml`]
                };
            }
     },

     'CustomPermission': {
        folderName: 'customPermissions',
        getFileAttributes: (member) => {
                return {
                    folderName: `customPermissions`,
                    fileNames: [ `${member}.customPermission-meta.xml`]
                };
            }
     },

     // TODO
     'Document': {
        folderName: 'documents',
        getFileAttributes: (member) => {
            return {
                folderName: `documents`,
                fileNames: [ `${member}`]
            };
        },
        copyAllFiles: true
    },

    'Report': {
        folderName: 'reports',
        getFileAttributes: (member) => {
            const parts = member.split('/');
            if (parts.length === 2) {
                const [folder, filename] = parts;
                return {
                    folderName: `reports/${folder}`,
                    fileNames: [ `${filename}.report-meta.xml`]
                };
            }
            return {
                folderName: 'objects',
                fileNames: [ '']
            };
        }
    },


     





     'LightningComponentBundle': {
        folderName: 'lwc',
        getFileAttributes: (member) => {
            return {
                folderName: `lwc`,
                fileNames: [ `${member}`]
            };
        },
        copyAllFiles: true
    },

    'ExperienceBundle': {
        folderName: 'experiences',
        getFileAttributes: (member) => {
            return {
                folderName: `experiences`,
                fileNames: [ `${member}`,  `${member}.site-meta.xml`]
            };
        },
        copyAllFiles: true
    },


    'AuraDefinitionBundle': {
        folderName: 'aura',
        getFileAttributes: (member) => {
            return {
                folderName: `aura`,
                fileNames: [ `${member}`]
            };
        },
        copyAllFiles: true
    },

    'WaveDataset': {
        folderName: 'wave',
        getFileAttributes: (member) => {
            return {
                folderName: `wave`,
                fileNames: [  `${member}.wds-meta.xml`,  `${member}.xmd-meta.xml`]
            };
        }
     },

     'WaveDataset': {
        folderName: 'wave',
        getFileAttributes: (member) => {
            return {
                folderName: `wave`,
                fileNames: [  `${member}.wds-meta.xml`,  `${member}.xmd-meta.xml`]
            };
        }
     },
     

     'WaveDashboard': {
        folderName: 'wave',
        getFileAttributes: (member) => {
            return {
                folderName: `wave`,
                fileNames: [ `${member}.wdash`, `${member}.wdash-meta.xml`]
            };
        }
     },

     'WaveDataflow': {
        folderName: 'wave',
        getFileAttributes: (member) => {
            return {
                folderName: `wave`,
                fileNames: [ `${member}.wdf`, `${member}.wdf-meta.xml`]
            };
        }
     },

     'WaveLens': {
        folderName: 'wave',
        getFileAttributes: (member) => {
            return {
                folderName: `wave`,
                fileNames: [ `${member}.wlens`, `${member}.wlens-meta.xml`]
            };
        }
     },


     'WaveRecipe': {
        folderName: 'wave',
        getFileAttributes: (member) => {
            return {
                folderName: `wave`,
                fileNames: [ `${member}.wdpr`, `${member}.wdpr-meta.xml`]
            };
        }
     },

     'WaveXmd': {
        folderName: 'wave',
        getFileAttributes: (member) => {
            return {
                folderName: `wave`,
                fileNames: [  `${member}.xmd-meta.xml`]
            };
        }
     },



     'CustomMetadata': {
        folderName: 'customMetadata',
        getFileAttributes: (member) => {
            return {
                folderName: `customMetadata`,
                fileNames: [ `${member}.md-meta.xml`]
            };
        }
     },


     'CustomLabel': {
        once: true,
        folderName: 'labels',
        getFileAttributes: (member) => {
            return {
                folderName: `labels`,
                fileNames: [ `CustomLabels.labels-meta.xml`]
            };
        },
        copyAllFiles: false
    },


    'StaticResource': {
        once: true,
        folderName: 'staticresources',
        getFileAttributes: (member) => {
            return {
                folderName: `staticresources`,
                fileNames: [ ``]
            };
        },
        copyAllFiles: true
    },

    'EmailTemplate': {
        folderName: 'email',
        getFileAttributes: (member) => {
            return {
                folderName: `email`,
                fileNames: [ ``]
            };
        },
        copyAllFiles: true
    },

    'Dashboard': {
        folderName: 'dashboards',
        getFileAttributes: (member) => {
            return {
                folderName: `dashboards`,
                fileNames: [ ``]
            };
        },
        copyAllFiles: true
    },


    'PathAssistant': {
        folderName: 'pathAssistants',
        getFileAttributes: (member) => {
                return {
                    folderName: `pathAssistants`,
                    fileNames: [ `${member}.pathAssistant-meta.xml`]
                };
            }
     },



    'GlobalValueSet': {
        folderName: 'globalValueSets',
        getFileAttributes: (member) => {
                return {
                    folderName: `globalValueSets`,
                    fileNames: [ `${member}.globalValueSet-meta.xml`]
                };
            }
     },

    'CustomTab': {
        folderName: 'tabs',
        getFileAttributes: (member) => {
                return {
                    folderName: `tabs`,
                    fileNames: [ `${member}.tab-meta.xml`]
                };
            }
     },

    'CustomObject': {
        folderName: 'objects',
        getFileAttributes: (member) => {
                return {
                    folderName: `objects/${member}`,
                    fileNames: [ `${member}.object-meta.xml`]
                };
            }
     },

    'CustomField': {
        folderName: 'objects',
        getFileAttributes: (member) => {
            const parts = member.split('.');
            if (parts.length === 2) {
                const [folder, filename] = parts;
                return {
                    folderName: `objects/${folder}/fields`,
                    fileNames: [ `${filename}.field-meta.xml`]
                };
            }
            return {
                folderName: 'objects',
                fileNames: [ '']
            };
        }
    },
 


    'CompactLayout': {
        folderName: 'objects',
        getFileAttributes: (member) => {
            const parts = member.split('.');
            if (parts.length === 2) {
                const [folder, filename] = parts;
                return {
                    folderName: `objects/${folder}/compactLayouts`,
                    fileNames: [ `${filename}.compactLayout-meta.xml`]
                };
            }
            return {
                folderName: 'objects',
                fileNames: [ '']
            };
        }
    },
    'ListView': {
        folderName: 'objects',
        getFileAttributes: (member) => {
            const parts = member.split('.');
            if (parts.length === 2) {
                const [folder, filename] = parts;
                return {
                    folderName: `objects/${folder}/listViews`,
                    fileNames: [ `${filename}.listView-meta.xml`]
                };
            }
            return {
                folderName: 'objects',
                fileNames: [ '']
            };
        }
    },

    'RecordType': {
        folderName: 'objects',
        getFileAttributes: (member) => {
            const parts = member.split('.');
            if (parts.length === 2) {
                const [folder, filename] = parts;
                return {
                    folderName: `objects/${folder}/recordTypes`,
                    fileNames: [ `${filename}.recordType-meta.xml`]
                };
            }
            return {
                folderName: 'objects',
                fileNames: [ '']
            };
        }
    },


    'ValidationRule': {
        folderName: 'objects',
        getFileAttributes: (member) => {
            const parts = member.split('.');
            if (parts.length === 2) {
                const [folder, filename] = parts;
                return {
                    folderName: `objects/${folder}/validationRules`,
                    fileNames: [ `${filename}.validationRule-meta.xml`]
                };
            }
            return {
                folderName: 'objects',
                fileNames: [ '']
            };
        }
    },
    // Add more mappings for other types if needed
}

}
