# If not running interactively, don't do anything
[[ $- != *i* ]] && return
cyan=$(tput setaf 6)
purple=$(tput setaf 5)
reset=$(tput sgr0)
PS1='\[$purple\][\[$cyan\]\u \W\[$purple\]]$ \[$reset\]'
#PS1='\e[0;35m[\e[m\e[0;36m\u \W\e[m\e[0;35m]\$\e[m '

shopt -s checkwinsize

alias ls='ls --color=auto'
alias ll='ls -lhtr --color=auto'
alias vi='vim'
alias psg=' ps -ef | grep -v grep | grep -i '
alias bfeed='ssh -oStrictHostKeyChecking=off gmoy@35.246.78.170'
alias wk="cd ~/workspace"
alias k="rlwrap k"
alias vpn='protonvpn'
export GOPATH='/home/gmoy/go'
export GIT_EDITOR='vim'

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
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

function dprune() {
    docker system prune -f --volumes
}

function dra() {
    for cntr in `docker container ps -a | awk '{print $1}' | tail -n +2`; do
        docker container stop $cntr
        docker container rm $cntr
    done
}

function dls() {
    docker container ps -a
}
