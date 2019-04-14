//*** DESCRIPTION

/
Toolbox

This is helper script to allow loading of files in a safe and controlled way

\

//*** GLOBAL VARS

// Create the paths where files will be searched for
.ld.PATH:hsym`$getenv[`QPATH`QHOME];
.ld.LOADED:`symbol$();

// Level of filesystem depth to recursively check for the requested file
// if you have a highly nested file setup then this can be increased to improve search results
.ld.DEPTH:10;

// *** FUNCTIONS

// File to recursively check the library directories for file names that match
.ld.findFile:{[root;file;depth]
    if[depth<1;:key[root] where key[root] like ("*/",file)];
    $[11h=type subdir:key root;
        .z.s[;file;depth-1] each ` sv/:root,/:subdir;
        subdir like ("*",file);
            subdir;
            `symbol$() 
        ]
    }

// Simple file loader system command wrapper
.ld.read:{[fp]
    system"l ",.util.string fp;
    }

// Load a file and if it should only be loaded once then add it to the LOADED list
.ld.load:{[file;once]
    chkPath:@[.ld.read;file;0b];
    if[not chkPath~0b;
        .log.info("File loaded:";file);
        if[once;.ld.LOADED,::`$file];
        :()
        ];
    filepath:first (raze/).ld.findFile[;.util.string file;.ld.DEPTH] each .ld.PATH;
    if[null filepath;.log.info("Could not find file";file);:()];
    if[(filepath in .ld.LOADED) & once;
        .log.info("File already loaded";filepath);
        :()];
    chkLoad:@[.ld.read;filepath;0b];
    $[chkLoad~0b;
        .log.info("Could not load file:";filepath);
        [.log.info("File loaded:";filepath);
        if[once;.ld.LOADED,::filepath]]
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
.ld.require `/Users/gmoy/q/q.q;
