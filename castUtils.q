//*** DESCRIPTION
/
Simple helper functions for kdb usage
\

// *** FUNCTIONS
.util.nlist:{
    $[0<type x;
        enlist x;
        x
        ]
    }

.util.string:{
    $[10h~abs t:type x;
        x;
        t in 98 99h;
        .Q.s x;
        string x]
    }

.util.symbol:{
    $[11h~abs type x;
        x;
        `$.util.string x
        ]
    }
