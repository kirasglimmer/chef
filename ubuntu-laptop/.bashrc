##############################################################################################3
# Setup git-prompt
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1

# ----------------------------------------------------------------
# Load in the git branch prompt script.
# http://code-worrier.com/blog/git-branch-in-bash-prompt/
# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
source ~/.git-prompt.sh

# original PS1 (LM17.1)
# ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\]

PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w$(__git_ps1 " (%s)")\$\[\033[00m\] '

