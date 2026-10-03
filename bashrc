export PATH=$PATH:/home/alec/.cargo/bin

# Virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
# source /etc/profiles/per-user/alec/bin/virtualenvwrapper.sh

# pnpm
export PNPM_HOME="/home/alec/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Add Go executable path wherever it's installed
export PATH="$PATH:$(go env GOPATH)/bin"

# Run direnv
eval "$(direnv hook bash)"

# Add .NET Core SDK tools
export PATH="$PATH:/home/alec/.dotnet/tools"

# Aliases
alias rm="rm -i"
alias ls="ls -lAs"

if [[ -f $HOME/git-completion.bash ]]; then
    source "$HOME/git-completion.bash"
fi

# Open up a Zellij tab if it isn't open already
if [[ ! -v ZELLIJ ]]; then
    zellij --layout "$ZELLIJ_DEFAULT_PROFILE"
fi
