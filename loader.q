//*** DESCRIPTION

/
Toolbox

This is helper script to allow loading of files in a safe and controlled way

\

//*** COMMAND LINE PARAMS

// params:.Q.def[enlist[`date]!enlist .z.D-1].Q.opt .z.x;

//*** REQUIRED SCRIPTS

//*** HANDLES

//*** GLOBAL VARS

// Create the paths where files will be searched for
.ld.PATH:hsym`$getenv[`QPATH`QHOME];
.ld.LOADED

// *** FUNCTIONS
.ld.load:{[filepath;once]
    @[system;"l ";..info];
    if[once;.ld.LOADED,::filepath];
    }

.ld.findFile:{[root;file]
    
    }

.ld.chk:{[filepath]
    filepath in .ld.LOADED
    }

.ld.require:{[file]
    
    }

.ld.

//*** RUNNER
.ld.require["toolbox/log.q"];
