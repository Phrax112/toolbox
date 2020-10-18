//*** DESCRIPTION
/
Logging utilities for the q programming language
Can log to a standardised location or to the stdout
\

//*** GLOBAL VARS

// This is where all the information about where the logs are sent is kept
.log.OUT:()!();

// This defined wherther to write to stdout or the logfile
// Specify `stdout for stdout and `file for the logfile
//.log.WRITEOUT:`file;
.log.WRITEOUT:`stdout;

// *** FUNCTIONS

// Standardised log file naming convention function
// Log name is based on script name and date
.log.getLogFile:{
    `$("_" sv .util.string@/:(first "." vs last "/" vs string .z.f;.z.D)),".log"
    }

// Locate where the logs should be stored
// if none of the variables are defined then store them in the working directory
.log.getLogDir:{
    @[value;`.log.LOGDIR;@[value;hsym `$getenv[`KDBLOG];hsym `$first system"pwd"]]
    }

// Set the log information as a globally defined dictionary
.log.setOut:{
    out:enlist[`]!enlist[::];
    out[`file]:.log.getLogFile[];
    out[`dir]:.log.getLogDir[];
    out[`logpath]:.Q.dd . out[`dir`file];
    out[`date]:.z.D;
    out[`out]:.log.WRITEOUT;
    out[`INFO]:$[out[`out]~`stdout;-1;neg hopen out[`logpath]];
    out[`ERROR]:$[out[`out]~`stdout;-2;neg hopen out[`logpath]];
    .log.OUT:out;
    }

// Format the messages passed to the log functions
// Dictionaries and tables will be on new lines
// Everything else is seperated by | markers
.log.fmt:{[str;t]
    str:trim str;
    $[any t within/:((0;9h);(11;97h));
        raze[str]," ";
        t in 98 99h;
            "\n",str;
            str," "
            ] 
    }

// Get the handle to send the logs to
// Handle will be <0 for sending to a file and -1 otherwise
.log.getHandle:{[lvl]
    if[not .z.D~.log.OUT[`date];
        .log.setOut[]];
    .log.OUT lvl
    }

// Send the message to the log location
// If something is broken then set the log handle to standard out
.log.sendMsg:{[lvl;msg]
    h:.log.getHandle[lvl];
    @[h;msg;{[x;y].log.OUT[x]::$[x~`ERROR;-2;-1];-2"Unable to send to handle:",.Q.s y}[lvl;]];
    }

// Helper function to output a message to a log location with a certain urgency indicator
.log.out:{[msg;lvl]
    ts:type@/:out:.z.P,"|",lvl,"|",.util.nlist msg;
    .log.sendMsg[lvl;] (raze/).log.fmt'[.util.string@/:out;ts];
    }

// Use to send normal messages to the log file
// e.g. .log.info("This is a log message";`a`b`c!1 2 3;([]sym:10?`3;price:10?10))
.log.info:.log.out[;`INFO];

// USe to send error messages then they occur, same parameters as .log.info
.log.error:.log.out[;`ERROR];

//*** RUNNER
.log.setOut[];
