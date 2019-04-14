export QHOME=/Users/gmoy/q
export QINIT=/Users/gmoy/Documents/GitHub/toolbox/init.q
export GOPATH=/Users/gmoy/go
export PATH=$PATH:/Users/gmoy/q/m64
export PATH=$PATH:$GOPATH/bin
export QPATH=/Users/gmoy/Documents/GitHub
export LOGTP=/Users/gmoy/projects/qlogTP/
alias q="rlwrap -c /Users/gmoy/q/m64/q"
alias q32="rlwrap -c /Users/gmoy/q/m32/q"
alias psg="ps -ef | grep -v grep | grep "

export KX_SSL_HOME=$HOME/.ssh/tls_certs
export KX_SSL_CERT_FILE=$KX_SSL_HOME/server-crt.pem
export KX_SSL_CA_CERT_FILE=$KX_SSL_HOME/ca.pem
export KX_SSL_CA_CERT_PATH=$KX_SSL_HOME
export KX_SSL_KEY_FILE=$KX_SSL_HOME/server-key.pem
export KX_SSL_CIPHER_LIST=ALL
export KX_SSL_VERIFY_CLIENT=YES
export KX_SSL_VERIFY_SERVER=YES

# cC p.c -ledit
cC () {
    cFile=$1
    eFile=`basename $cFile .c`
    cc -std=c99 -Wall $2 $cFile -o $eFile
    echo "$cFile --> $eFile"
}
