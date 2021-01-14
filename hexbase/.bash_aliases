alias lsg="ls -aF | grep";
alias hisg="history | grep";

PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;34m\]\w\[\033[00m\]\$ ";
export PS1;
export LANG=C.UTF-8
