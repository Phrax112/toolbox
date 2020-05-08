export QHOME=/Users/gmoy/Downloads/m64
export QINIT=/Users/gmoy/Documents/GitHub/toolbox/init.q
export GOPATH=$HOME/go
export PATH=$PATH:/Users/gmoy/Downloads/m64/m64
export PATH=$PATH:$GOPATH/bin
export PATH=/usr/local/opt/ruby/bin:$PATH
export PATH=/Users/gmoy/.gem/ruby/2.6.0/bin:$PATH
export QPATH=/Users/gmoy/Documents/GitHub
export LOGTP=/Users/gmoy/projects/qlogTP/
export RASPI=192.168.1.15
alias Q="rlwrap -c /Users/gmoy/Downloads/m64/m64/q"
alias q32="rlwrap -c /Users/gmoy/q/m32/q"
alias psg="ps -ef | grep -v grep | grep "
alias python='python3.7'
alias pip='pip3.7'

export LC_ALL=en_US.UTF-8

export KX_SSL_HOME=$HOME/.ssh/tls_certs
export KX_SSL_CERT_FILE=$KX_SSL_HOME/server-crt.pem
export KX_SSL_CA_CERT_FILE=$KX_SSL_HOME/ca.pem
export KX_SSL_CA_CERT_PATH=$KX_SSL_HOME
export KX_SSL_KEY_FILE=$KX_SSL_HOME/server-key.pem
export KX_SSL_CIPHER_LIST=ALL
export KX_SSL_VERIFY_CLIENT=YES
export KX_SSL_VERIFY_SERVER=YES

# nvm setup
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# cC p.c -ledit
cC () {
    cFile=$1
    eFile=`basename $cFile .c`
    cc -std=c99 -Wall $2 $cFile -o $eFile
    echo "$cFile --> $eFile"
}

eval $(docker-machine env)
