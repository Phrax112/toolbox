//*** DESCRIPTION

/
Simple q.q replacement to load in the toolbox utilities in the correct order
\

//*** REQUIRED SCRIPTS
.tb.ROOT:first ` vs hsym`$getenv`QINIT;
system"l ",string ` sv (.tb.ROOT;`utilities.q);
system"l ",string ` sv (.tb.ROOT;`log.q);
system"l ",string ` sv (.tb.ROOT;`loader.q);
