//*** DESCRIPTION

/
Toolbox

This is helper script to allow loading of files in a safe and controlled way

\

//*** GLOBAL VARS

// Create the paths where files will be searched for
.ld.PATH:hsym`$getenv[`QPATH`QHOME];
.ld.LOADED:enlist[`]!();

// Level of filesystem depth to recursively check for the requested file
// if you have a highly nested file setup then this can be increased to improve search results
.ld.DEPTH:10;

// *** FUNCTIONS

// File to recursively check the library directories for file names that match
.ld.findFile:{[root;file;depth]
    if[depth<1;
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

// If you want to enforce a file is loaded only once use require
.ld.require:.ld.load[;1b];

// If a file can be loaded multiple times use the get function
.ld.get:.ld.load[;0b];

/ 
Example:

.ld.require "toolbox/castUtils.q";
.ld.get "castUtils.q";
.ld.require `:/Users/gmoy/q/q.q;
