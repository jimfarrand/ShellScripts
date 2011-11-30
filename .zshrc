##
# Jim's ZSH config file

# Local configuration goes in .zshrc.hostname...
LOCAL="$HOME/.zshrc.$HOST"
if [ -e  "$LOCAL" ] ; then
  . "$LOCAL"
fi

