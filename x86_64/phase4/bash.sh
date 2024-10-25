# Bash Phase 4
./configure --prefix=/usr \
	--without-bash-malloc \
	--with-installed-readline \
	bash_cv_strtold_broken=no \
	--docdir=/usr/share/doc/bash-5.2.32
make

if $RUN_TESTS; then
	set +e
	chown -R tester .
	su -s /usr/bin/expect tester <<EOF
set timeout -1
spawn make tests
expect eof
lassign [wait] _ _ _ value
exit $value
EOF
	set -e
fi

make install

cat >/etc/profile <<"EOF"
# Begin /etc/profile
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# modifications by Dagmar d'Surreal <rivyqntzne@pbzpnfg.arg>

# System wide environment variables and startup programs.

# System wide aliases and functions should go in /etc/bashrc.
# Personal environment variables and startup programs should go into
# ~/.bash_profile. Personal aliases and functions should go into
# ~/.bashrc.

# Functions to help us manage paths. The second argument is the name of the
# path variable to be modified (default: PATH)
pathremove() {
    local IFS=':'
    local NEWPATH
    local DIR
    local PATHVARIABLE=${2:-PATH}
    for DIR in ${!PATHVARIABLE}; do
        if [ "$DIR" != "$1" ]; then
            NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
        fi
    done
    export $PATHVARIABLE="$NEWPATH"
}

pathprepend() {
    pathremove "$1" "$2"
    local PATHVARIABLE=${2:-PATH}
    export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

pathappend() {
    pathremove "$1" "$2"
    local PATHVARIABLE=${2:-PATH}
    export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}

export -f pathremove pathprepend pathappend

# Set the initial path
export PATH=/usr/bin

# Attempt to provide backward compatibility with LFS earlier than 11
if [ ! -L /bin ]; then
    pathappend /bin
fi

if [ $EUID -eq 0 ]; then
    pathappend /usr/sbin
    if [ ! -L /sbin ]; then
        pathappend /sbin
    fi
    unset HISTFILE
fi

# Set up some environment variables.
export HISTSIZE=1000
export HISTIGNORE="&:[bf]g:exit"

# Set some defaults for graphical systems
export XDG_DATA_DIRS=${XDG_DATA_DIRS:-/usr/share/}
export XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:-/etc/xdg/}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/tmp/xdg-$USER}

# Function to set the prompt color based on the provided argument
set_prompt_color() {
    local color
    case "$1" in
        blue)
            color="\[\e[1;34m\]"
            ;;
        red)
            color="\[\e[1;31m\]"
            ;;
        pink)
            color="\[\e[1;35m\]"
            ;;
        yellow)
            color="\[\e[1;33m\]"
            ;;
        green)
            color="\[\e[1;32m\]"
            ;;
        cyan)
            color="\[\e[1;36m\]"
            ;;
        white)
            color="\[\e[1;37m\]"
            ;;
        *)
            color="\[\e[1;32m\]"
            ;;
    esac
    export PS1="${color}\u [ \[\e[0m\]\w${color} ]\$ \[\e[0m\]"
}

# Set up the prompt color based on the command-line argument
if [[ $EUID == 0 ]]; then
    set_prompt_color "red"
else
    set_prompt_color "green"
fi

# Source individual scripts in /etc/profile.d directory
for script in /etc/profile.d/*.sh; do
    if [ -r "$script" ]; then
        . "$script"
    fi
done

unset script

# Alias to change prompt color or list available colors
colour() {
    if [[ "$1" == "-l" ]]; then
        echo "Available colors: blue, red, pink, yellow, green, cyan, white"
    else
        set_prompt_color "$1"
    fi
}

show() {
  echo -n "Enter the folder or file name you are looking for: "
  read -r search_name

  # Use find command to search for matching folders or files
  folder_result=$(find / -path "/run" -prune -o -type d -name "*$search_name*" -print 2>/dev/null)
  file_result=$(find / -path "/run" -prune -o -type f -name "*$search_name*" -print 2>/dev/null)

  if [ -z "$folder_result" ] && [ -z "$file_result" ]; then
    echo "No matching folder or file found."
  else
    echo -n "Searching for '$search_name'"
    while true; do
      echo -n "."
      sleep 0.5
      echo -n "."
      sleep 0.5
      echo -n "."
      sleep 0.5
      break
    done
    echo

    echo "Matching folders:"
    if [ -z "$folder_result" ]; then
      echo "None"
    else
      num_folders=$(echo "$folder_result" | wc -l)
      echo "$num_folders folder(s) found:"
      i=1
      while IFS= read -r folder; do
        echo "$i. $folder"
        ((i++))
      done <<< "$folder_result"
    fi

    echo "Matching files:"
    if [ -z "$file_result" ]; then
      echo "None"
    else
      num_files=$(echo "$file_result" | wc -l)
      echo "$num_files file(s) found:"
      i=1
      while IFS= read -r file; do
        echo "$i. $file"
        ((i++))
      done <<< "$file_result"
    fi

    while true; do
      echo "Enter the number corresponding to the desired location (or 'q' to quit): "
      read -r choice

      if [[ $choice == q ]]; then
        echo "Exiting."
        break
      elif [[ $choice =~ ^[0-9]+$ ]]; then
        total_results=$((num_folders + num_files))
        if ((choice >= 1 && choice <= total_results)); then
          if ((choice <= num_folders)); then
            selected_result=$(echo "$folder_result" | sed -n "${choice}p")
          else
            selected_result=$(echo "$file_result" | sed -n "$((choice - num_folders))p")
          fi
          cd "$(dirname "$selected_result")"
          exec bash
          break
        fi
      fi

      echo "Invalid choice. Please try again."
    done
  fi
}

# End /etc/profile
EOF

install --directory --mode=0755 --owner=root --group=root /etc/profile.d

cat >/etc/profile.d/bash_completion.sh <<"EOF"
# Begin /etc/profile.d/bash_completion.sh
# Import bash completion scripts

# If the bash-completion package is installed, use its configuration instead
if [ -f /usr/share/bash-completion/bash_completion ]; then

  # Check for interactive bash and that we haven't already been sourced.
  if [ -n "${BASH_VERSION-}" -a -n "${PS1-}" -a -z "${BASH_COMPLETION_VERSINFO-}" ]; then

    # Check for recent enough version of bash.
    if [ ${BASH_VERSINFO[0]} -gt 4 ] || \
       [ ${BASH_VERSINFO[0]} -eq 4 -a ${BASH_VERSINFO[1]} -ge 1 ]; then
       [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion" ] && \
            . "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion"
       if shopt -q progcomp && [ -r /usr/share/bash-completion/bash_completion ]; then
          # Source completion code.
          . /usr/share/bash-completion/bash_completion
       fi
    fi
  fi

else

  # bash-completions are not installed, use only bash completion directory
  if shopt -q progcomp; then
    for script in /etc/bash_completion.d/* ; do
      if [ -r $script ] ; then
        . $script
      fi
    done
  fi
fi

# End /etc/profile.d/bash_completion.sh
EOF

install --directory --mode=0755 --owner=root --group=root /etc/bash_completion.d

cat >/etc/profile.d/dircolors.sh <<"EOF"
# Setup for /bin/ls and /bin/grep to support color, the alias is in /etc/bashrc.
if [ -f "/etc/dircolors" ] ; then
        eval $(dircolors -b /etc/dircolors)
fi

if [ -f "$HOME/.dircolors" ] ; then
        eval $(dircolors -b $HOME/.dircolors)
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
EOF

cat >/etc/profile.d/extrapaths.sh <<"EOF"
if [ -d /usr/local/lib/pkgconfig ] ; then
        pathappend /usr/local/lib/pkgconfig PKG_CONFIG_PATH
fi
if [ -d /usr/local/bin ]; then
        pathprepend /usr/local/bin
fi
if [ -d /usr/local/sbin -a $EUID -eq 0 ]; then
        pathprepend /usr/local/sbin
fi

if [ -d /usr/local/share ]; then
        pathprepend /usr/local/share XDG_DATA_DIRS
fi

# Set some defaults before other applications add to these paths.
pathappend /usr/share/man  MANPATH
pathappend /usr/share/info INFOPATH
EOF

cat >/etc/profile.d/readline.sh <<"EOF"
# Set up the INPUTRC environment variable.
if [ -z "$INPUTRC" -a ! -f "$HOME/.inputrc" ] ; then
        INPUTRC=/etc/inputrc
fi
export INPUTRC
EOF

cat >/etc/profile.d/umask.sh <<"EOF"
# By default, the umask should be set.
if [ "$(id -gn)" = "$(id -un)" -a $EUID -gt 99 ] ; then
  umask 002
else
  umask 022
fi
EOF

cat >/etc/bashrc <<"EOF"
# Begin /etc/bashrc
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# updated by Bruce Dubbs <bdubbs@linuxfromscratch.org>

# System wide aliases and functions.

# System wide environment variables and startup programs should go into
# /etc/profile.  Personal environment variables and startup programs
# should go into ~/.bash_profile.  Personal aliases and functions should
# go into ~/.bashrc

# Provides colored /bin/ls and /bin/grep commands.  Used in conjunction
# with code in /etc/profile.

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Provides prompt for non-login shells, specifically shells started
# in the X environment. [Review the LFS archive thread titled
# PS1 Environment Variable for a great case study behind this script
# addendum.]

NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[1;32m\]"
if [[ $EUID == 0 ]] ; then
  PS1="$RED\u [ $NORMAL\w$RED ]# $NORMAL"
else
  PS1="$GREEN\u [ $NORMAL\w$GREEN ]\$ $NORMAL"
fi

unset RED GREEN NORMAL

# End /etc/bashrc
EOF

cat >~/.bash_profile <<"EOF"
# Begin ~/.bash_profile
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# updated by Bruce Dubbs <bdubbs@linuxfromscratch.org>

# Personal environment variables and startup programs.

# Personal aliases and functions should go in ~/.bashrc.  System wide
# environment variables and startup programs are in /etc/profile.
# System wide aliases and functions are in /etc/bashrc.

if [ -f "$HOME/.bashrc" ] ; then
  source $HOME/.bashrc
fi

if [ -d "$HOME/bin" ] ; then
  pathprepend $HOME/bin
fi

# Having . in the PATH is dangerous
#if [ $EUID -gt 99 ]; then
#  pathappend .
#fi

# End ~/.bash_profile
EOF

cat >~/.profile <<"EOF"
# Begin ~/.profile
# Personal environment variables and startup programs.

if [ -d "$HOME/bin" ] ; then
  pathprepend $HOME/bin
fi

# Set up user specific i18n variables
#export LANG=<ll>_<CC>.<charmap><@modifiers>

# End ~/.profile
EOF

cat >~/.bashrc <<"EOF"
# Begin ~/.bashrc
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>

# Personal aliases and functions.

# Personal environment variables and startup programs should go in
# ~/.bash_profile.  System wide environment variables and startup
# programs are in /etc/profile.  System wide aliases and functions are
# in /etc/bashrc.

if [ -f "/etc/bashrc" ] ; then
  source /etc/bashrc
fi

# Set up user specific i18n variables
#export LANG=<ll>_<CC>.<charmap><@modifiers>
# expot for go lang
#export PATH=$PATH:/usr/local/go/bin

# End ~/.bashrc
EOF

cat >~/.bash_logout <<"EOF"
# Begin ~/.bash_logout
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>

# Personal items to perform on logout.

# End ~/.bash_logout
EOF

dircolors -p >/etc/dircolors

echo "bash installed on $(date)" >>/var/log/packages.log
#exec /usr/bin/bash --login
