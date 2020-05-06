//*** DESCRIPTION

/
Toolbox

This is a helper script to allow loading of files in a safe and controlled way

The logic works as following
    1) The filepath passed is checked to see if it is valid
    2) If it is then the file is loaded
    3) If the filepath passed is not valid then the set directories are recursively searched
    4) If any file matching the one passed is found then it is loaded
    5) If no file is found that matches the value passed then nothing is done

If it is specified that the file should only be loaded once then a has of its contnets is added to the .ld.LOADED dictionary. This is checked against for every subsequent file load to ensure that it is not loaded again

To add root dierctories under which files should be looked for then just add them under the .ld.PATH variable.

By default the root directories that are searched are those defined by the QPATH and QHOME environmental variables

\

//*** GLOBAL VARS

// Create the paths where files will be searched for
.ld.PATH:hsym`$getenv[`QPATH`QHOME];

// Define the dictioanry where the hashes of loaded files will be kept
.ld.LOADED:enlist[`]!();

// Level of filesystem depth to recursively check for the requested file
// if you have a highly nested file setup then this can be increased to improve search results
.ld.DEPTH:10;

// *** FUNCTIONS

// File to recursively check the library directories for file names that match
.ld.findFile:{[root;file;depth]
    if[(depth<1) & (11h=type key[root]);
        :key[root] where key[root] like ("*/",file)];
    $[11h=type subdir:key root;
        .z.s[;file;depth-1] each ` sv/:root,/:subdir;
        subdir like ("*",file);
            subdir;
            `symbol$() 
        ]
    }

// Create an md5 hash of a file
// Only reads the first 1000 bytes to speed up calculation
.ld.getHash:{[fp]
    md5 raze read0(hsym .util.symbol fp;0;1000)
    }

// File loader system command wrapper
// Checks whether the file has been loaded fron a hash of its contents
// Returns the status of the file load back to the requestor 
.ld.read:{[fp;once]
    hash:.ld.getHash fp;
    status:$[not once;
        [system"l ",.util.string fp;
            0];
        hash in .ld.LOADED;
            1;
            [system"l ",.util.string fp;
                .ld.LOADED[.util.symbol fp]::hash;
                2]
            ];
    (`force`exst`new)status
    }

// Load a file and if it should only be loaded once then add it to the LOADED list
.ld.load:{[file;once] 
    chkPath:.[.ld.read;(file;once);`chkpth];
    $[chkPath in `force`new;
        [.log.info("File loaded:";file);:()];
        if[chkPath in `exst;
            .log.info("File already loaded";file);:()]
        ];
    filepath:first (raze/).ld.findFile[;.util.string file;.ld.DEPTH] each .ld.PATH;
    if[null filepath;.log.info("Could not find file";file);:()];
    chkLoad:.[.ld.read;(filepath;once);`loadError];
    $[chkLoad in `force`new;
        .log.info("File loaded:";filepath);
        chkLoad in `exst;
            .log.info("File alredy loaded";filepath);
            .log.info("File load error";filepath)
        ];
    }

// If you want to enforce a file is loaded only once use getOnce
.ld.getOnce:.ld.load[;1b];

// If a file can be loaded multiple times use the get function
.ld.get:.ld.load[;0b];

/ 
Example:

.ld.getOnce "toolbox/castUtils.q";
.ld.get "castUtils.q";
.ld.getOnce `:/Users/gmoy/q/q.q;
