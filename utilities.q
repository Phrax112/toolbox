//*** DESCRIPTION
/
Simple helper functions for kdb usage
\

// helper function to be able to pass the error of an apply over a list
// .util.err[*;2;(1;2;2;`a);4#`NULL]
.util.err:{[f;x;y;e]
    .[;;]'[f;x,/:y;e]
    }

.util.userInput:{
    -2 x;
    read 0
    }

.util.stepGen:{[start;stop;step]
    l:step*(start+til  floor (stop%step)+1);
    l:l-(l[0]-start);
    l where l<=stop
    }

\d .Q
k)pdft2:{[d;p;f;t]
    $[0<#:!:fd:par[d;p;t];
        [if[~&/qm'r:+en[d]`. . `\:t;
                '`unmappable];
        {[d;t;i;x]@[d;x;,;t[x]i]}[fd;r;<r f]'!r;
        .q.xasc[f;fd];
        @[fd;f;`p#];
        :t
        ];
        dpft[d;p;f;t]]
    }
\d .

.util.slippage:{[side;mkt;est]
    10000*?[`B~side;(mkt-est)%mkt;(est-mkt)%mkt]
    }

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


.util.saveToHDB:{[d;p;f;n;t;o]
  fileName:` sv (d;`$string p;n;`);
  $[o;
    .[fileName;();:;.Q.en[d;t]];
    .[fileName;();,;.Q.en[d;t]]
    ]
  }

.util.sortHDB:{[d;p;f;n]
  fullPath:` sv (d;`$string p;n;`);
  xasc[f;fullPath];
  @[fullPath;f;`#p];
  }

.util.writeHDB:{[dir;part;field;name;data;overwrite]
  .util.saveToHDB[dir;part;field;name;data;overwrite];
  .util.sortHDB[dir;part;field;name];
  }
