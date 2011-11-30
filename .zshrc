##
# Jim's ZSH config file

##
# Check if we are running in stupid solaris
if uname -a | grep SunOS >/dev/null ; then
	SOLARIS_HACKS=true
fi

##
# If in solaris, try to fix up terminal type
if [ -n "$SOLARIS_HACKS" ] ; then
	if [ "$TERM" = "linux" -o "$TERM" = "xterm" -o "$TERM" = "screen" ] ; then
		TERM=dtterm
	fi
fi

###
# See if we can use colors.
autoload colors zsh/terminfo

# FIXME: This check breaks on my virt :/
#if [[ "$terminfo[colors]" -ge 8 ]]; then
	colors
#fi

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
	eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
	eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
	(( count = $count + 1 ))
done
PR_NO_COLOUR="%{$terminfo[sgr0]%}"

# Chose a colour for this host
case $HOST in
  (jfarrand-1.dub2.amazon.com) 	HOST_COLOUR=$PR_YELLOW ;;
  (*) 		HOST_COLOUR=$PR_RED ;;
esac

# Set our prompt, which looks like this:
PROMPT="[%B%(?.$PR_GREEN.$PR_RED)%?$PR_WHITE%(1j./%j.)%b]$HOST_COLOUR%m$PR_WHITE:%B%2~%b%(!.#.$) "

# This sets the title of the xterminal to include the name of the running program
case $TERM in (xterm*|rxvt|screen)
  precmd () {
        if [ -n "$SHELL_NAME" ] ; then
            SHELL_NAME_PROMPT="$SHELL_NAME: "
        fi

        if [ "$TERM" = "screen" ] ; then
                print -Pn "\ek%n@%m: %~\e\\"
        else
            print -Pn "\e]0;${SHELL_NAME_PROMPT}Shell in %2~ as %n on %m\a"
        fi
  }
  preexec () {
        if [ -n "$SHELL_NAME" ] ; then
            SHELL_NAME_PROMPT="$SHELL_NAME: "
        fi

        if [ "$TERM" = "screen" ] ; then
                print -Pn "\ek%n@%m: $1\e\\"
        else
                print -Pn "\e]0;${SHELL_NAME_PROMPT}$1 in %2~ as %n on %m\a"
        fi
  }
;;
esac

# Function to give a name to the current shell (which is displayed in the 
function shn {
    export SHELL_NAME="$1"
}

# Read in useful shell variables
if [ -e ".zshrc.variables.$HOST" ] ; then
    source ".zshrc.variables.$HOST"
fi

# Function to extend the path
function add_path {
    PATH="$PATH:$1"
}

# Add my scripts, if configured
if [ -d "$JIMS_SHELLSCRIPTS" ] ; then
    add_path "$JIMS_SHELLSCRIPTS"
fi

# I don't know what this does any more, but I think it's required for the
# bookmarking to work right in the bm script below.
if ! uname -a | grep >/dev/null Cygwin ; then
	# The following lines were added by compinstall

	zstyle ':completion:*' completer _complete
	zstyle :compinstall filename '/home/jim/.zshrc'

	autoload -Uz compinit
	compinit
	# End of lines added by compinstall
fi

# Directory bookmarking script
if [ -d "$JIMS_SHELLSCRIPTS" -a -e "$JIMS_SHELLSCRIPTS/bm" ] ; then
    source "$JIMS_SHELLSCRIPTS/bm"
fi


# Local configuration goes in .zshrc.hostname...
LOCAL="$HOME/.zshrc.$HOST"
if [ -e  "$LOCAL" ] ; then
  . "$LOCAL"
fi


