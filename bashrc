export PATH=$PATH:/home/alec/.cargo/bin

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
else
    echo "Zellij is already running"
fi
