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
# Prompt setup 

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
  (jfarrand-1.dub2.amazon.com) 	HOST_COLOUR=$PR_CYAN ;;
  (pyxis) 	HOST_COLOUR=$PR_BLUE ;;
  (mu)  	HOST_COLOUR=$PR_YELLOW ;;
  (*) 		HOST_COLOUR=$PR_RED ;;
esac


# Set our prompt, which looks like this:
PROMPT="[%B%(?.$PR_GREEN.$PR_RED)%?$PR_WHITE%(1j./%j.)%b]$HOST_COLOUR%m$PR_WHITE:%B%2~%b%(!.#.$) "

# This sets the title of the xterminal to include the name of the running program
case $TERM in (xterm*|rxvt|screen)
  precmd () {
        if [ -n "$SHELL_NAME" ] ; then
            SHELL_NAME_PROMPT="$SHELL_NAME"
        else
            SHELL_NAME_PROMPT="Shell"
        fi

        if [ "$TERM" = "screen" ] ; then
            #    print -Pn "\ek%n@%m: %~\e\\"
            #print -Pn "\ek${SHELL_NAME_PROMPT}Shell in %2~ as %n on %m\e\\"
            print -Pn "\ek${SHELL_NAME_PROMPT} | %2~ | %n@%m\e\\"
        else
            print -Pn "\e]0;${SHELL_NAME_PROMPT} | %2~ | %n@%m\a"
        fi
  }
  preexec () {
        if [ -n "$SHELL_NAME" ] ; then
            SHELL_NAME_PROMPT="$SHELL_NAME | "
        else
            SHELL_NAME_PROMPT=""
        fi

        if [ "$TERM" = "screen" ] ; then
                #print -Pn "\ek%n@%m: $1\e\\"
                #print -Pn "\ek${SHELL_NAME_PROMPT}$1 in %2~ as %n on %m\e\\"
                print -Pn "\ek${SHELL_NAME_PROMPT}$1 | %2~ | %n@%m\e\\"
        else
                print -Pn "\e]0;${SHELL_NAME_PROMPT}$1 | %2~ | %n@%m\a"
        fi
  }
;;
esac

# Function to give a name to the current shell (which is displayed in the 
function shn {
    export SHELL_NAME="$1"
}

##
# Read in useful shell variables
if [ -e ".zshrc.variables.$HOST" ] ; then
    source ".zshrc.variables.$HOST"
fi

##
# Function to extend the path
function add_path {
    PATH="$PATH:$1"
}

##
# Add my scripts, if configured
if [ -d "$JIMS_SHELLSCRIPTS" ] ; then
    add_path "$JIMS_SHELLSCRIPTS"
fi
#
# Screen chooser script, which reminds me I have logged in screens, and sets up
# aliases to activate them
if [ -e "$JIMS_SHELLSCRIPTS/screenchoose" ] ; then
  source "$JIMS_SHELLSCRIPTS/screenchoose"
fi

# Fix display and other stuff inside screen
function fixdisplay {
        # Fix $DISPLAY
	FILENAME="/tmp/.realdisplay.$USER.$SCREENNAME"
	if [ -e "$FILENAME" ] ; then
		NEWDISPLAY=`cat "$FILENAME"`
		if [ "$DISPLAY" != "$NEWDISPLAY" -a -n "$NEWDISPLAY" ] ; then
		    echo "DISPLAY taken from parent shell (now $NEWDISPLAY)"
		    export DISPLAY="$NEWDISPLAY"
		fi
	fi

        # Fix $GPG_AGENT_INFO
	FILENAME="/tmp/.realgpgagent.$USER.$SCREENNAME"
	if [ -e "$FILENAME" ] ; then
		NEWGPGAGENT=`cat "$FILENAME"`
		if [ "$GPG_AGENT_INFO" != "$NEWGPGAGENT" -a -n "$NEWGPGAGENT" ] ; then
		    echo "GPG_AGENT_INFO taken from parent shell"
		    export GPG_AGENT_INFO="$NEWGPGAGENT"
		fi
        fi

        # Fix SSH_AGENT_PID
	FILENAME="/tmp/.realsshagentpid.$USER.$SCREENNAME"
	if [ -e "$FILENAME" ] ; then
		NEW_SSH_AGENT_PID=`cat "$FILENAME"`
		if [ "$SSH_AGENT_PID" != "$NEW_SSH_AGENT_PID" ] ; then
		    echo "SSH_AGENT_PID taken from parent shell" # (Was: '$SSH_AGENT_PID' Now '$NEW_SSH_AGENT_PID'"
		    export SSH_AGENT_PID="$NEW_SSH_AGENT_PID"

                    if [ -n "SSH_AGENT_PID" ] ; then
                        export SSHAGENT=/usr/bin/ssh-agent
                        export SSHAGENTARGS="-s"
                    fi
		fi
        fi
#
        ## Fix SSH_AUTH_SOCK
	FILENAME="/tmp/.realsshauthsock.$USER.$SCREENNAME"
	if [ -e "$FILENAME" ] ; then
		NEW_SSH_AUTH_SOCK=`cat "$FILENAME"`
		if [ "$SSH_AUTH_SOCK" != "$NEW_SSH_AUTH_SOCK" ] ; then
		    echo "SSH_AUTH_SOCK taken from parent shell"
		    export SSH_AUTH_SOCK="$NEW_SSH_AUTH_SOCK"
		fi
        fi

        ## Fix SESSION_MANAGER
	FILENAME="/tmp/.realsessionmanager.$USER.$SCREENNAME"
	if [ -e "$FILENAME" ] ; then
		NEW_SESSION_MANAGER=`cat "$FILENAME"`
		if [ "$SESSION_MANAGER" != "$NEW_SESSION_MANAGER" ] ; then
		    echo "SESSION_MANAGER taken from parent shell"
		    export SESSION_MANAGER="$NEW_SESSION_MANAGER"
		fi
        fi
}

# Every now and then, fix the display
function periodic {
    if [ -n "$SCREENNAME" ] ; then
        fixdisplay
    fi
}
PERIOD=60


##
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

##
# Directory bookmarking script
if [ -d "$JIMS_SHELLSCRIPTS" -a -e "$JIMS_SHELLSCRIPTS/bm" ] ; then
    source "$JIMS_SHELLSCRIPTS/bm"
fi


##
# Local configuration goes in .zshrc.hostname...
LOCAL="$HOME/.zshrc.$HOST"
if [ -e  "$LOCAL" ] ; then
  . "$LOCAL"
fi

###
# Watch for logins, check every 20 seconds.
WATCH=notme
LOGCHECK=20
# jim logged on pts/32 from :0.0 at 13:15
WATCHFMT='%n %a %l from %m at %T'

###
# Report execution time if greater than 5 seconds
REPORTTIME=5
TIMEFMT="%J CPU: %*Er %*Uu %*Ss %P	Flts: %Fma %Rmi"

##
# Setup vim or vi as editor
if [ -e `which vim` ] ; then
	export VISUAL=vim
	export EDITOR=vim
    alias vi=vim
else
	export VISUAL=vi
	export EDITOR=vi
fi


###
# Locale
export LANG=en_GB.UTF-8

###
# History config
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt inc_append_history
setopt extended_history


# Interactive comments
setopt INTERACTIVECOMMENTS

##
# Colour grepping
export GREP_OPTIONS='--color=auto'

##
# Get bash help (which is useful and mostly applicable to zsh)
function help
{
    bash -c "help $1"
}   


##
# Aliases

alias h=history
alias hgr='history -d 1 | egrep'
alias safefs='encfs --idle=15 ~/.encfs/Safe ~/Safe && pushd ~/Safe'

# Trashcan script
if [ -e "$JIMS_SHELLESCRIPTS/trash" ] ; then
    alias rm="$HOME/scripts/trash -o -v"
fi

