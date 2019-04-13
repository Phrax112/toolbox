//*** DESCRIPTION

/
Toolbox

This is helper script to allow loading of files in a safe and controlled way

\

//*** GLOBAL VARS

// Create the paths where files will be searched for
.ld.PATH:hsym`$getenv[`QPATH`QHOME];
.ld.LOADED:`symbol$();

// *** FUNCTIONS

// File to recursively check the library directories for file names that match
.ld.findFile:{[root;file;depth]
    if[depth<1;:key[root] where key[root] like ("*/",file)];
    $[11h=type subdir:key root;
        .z.s[;file;depth-1] each ` sv/:root,/:subdir;
        subdir like ("*/",file);
            subdir;
            `symbol$() 
        ]
    }

// Load a file and if it should only be loaded once then add it to the LOADED list
.ld.load:{[file;once]
    filepath:first (raze/).ld.findFile[;.util.string file;10] each .ld.PATH;
    if[null filepath;.log.info("Could not find file";file);:()];
    if[(filepath in .ld.LOADED) & once;
        .log.info("File already loaded";filepath);
        :()];
    @[system;"l ",string filepath;{[x;y].log.info("Could not load file:";y;x)}[filepath;]];
    if[once;.ld.LOADED,::filepath];
    }

// If you want to enforce a file is loaded only once use require
.ld.require:.ld.load[;1b];

// If a file can be loaded multiple times use the get function
.ld.get:.ld.load[;0b];
