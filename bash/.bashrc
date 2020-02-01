# Bash initialization for interactive non-login shells and
# for remote shells (info "(bash) Bash Startup Files").

# Export 'SHELL' to child processes.  Programs such as 'screen'
# honor it and otherwise use /bin/sh.
export SHELL

if [[ $- != *i* ]]
then
    # We are being invoked from a non-interactive shell.  If this
    # is an SSH session (as in "ssh host command"), source
    # /etc/profile so we get PATH and other essential variables.
    [[ -n "$SSH_CLIENT" ]] && source /etc/profile

    # Don't do anything else.
    return
fi

# Source the system-wide file.
source /etc/bashrc

# Adjust the prompt depending on whether we're in 'guix environment'.
if [ -n "$GUIX_ENVIRONMENT" ]
then
    PS1="\[\e[32m\]\h\[\e[m\][env]:\[\e[35m\]\w\[\e[m\]\[\e[31m\]\\$\[\e[m\] "
else
    PS1="\[\e[32m\]\h\[\e[m\]:\[\e[35m\]\w\[\e[m\]\[\e[31m\]\\$\[\e[m\] "
fi

alias ls='ls -p --color=auto'
alias ll='ls -l'
alias la='ls -la'
alias grep='grep --color=auto'

# Emacs
alias mymacs="emacsclient -a \"\" -nw"

# Secrets
source ~/.secret-profile

# Guix
export GUIX_PROFILE="/home/akoppela/.guix-profile"
export PATH="$PATH:$GUIX_PROFILE/bin"

# Nix
export NIX_PATH="$NIX_PATH:/home/akoppela/channels"

# Certificates
export SSL_CERT_DIR="$GUIX_PROFILE/etc/ssl/certs"
export SSL_CERT_FILE="$GUIX_PROFILE/etc/ssl/certs/ca-certificates.crt"
