export ZSH=$HOME/.oh-my-zsh

HISTORY_IGNORE="(jwt-decode*|systemctl poweroff)"

ZSH_THEME="sunaku-zapling"

plugins=(git ssh-agent)

source $ZSH/oh-my-zsh.sh

eval "$(direnv hook zsh)"

# Soft disable 'exit' on dropdown terminals
protectDropdownTerminal () {
	ID=$(ps -p $$ -o ppid= | tr -d '[:space:]')
	PARAM=$(ps -p $ID o args=)
	if [[ $PARAM =~ "dropdown" ]];
	then
		alias exit="echo \"You should not exit a dropdown terminal!\" && printf 'Use \\\exit to force exit.\n'"
	fi
}

protectDropdownTerminal

# Source private stuff
[ -e ~/.private ] && source ~/.private

# Dialog before doing stupid stuff
function git() {
    confirm=0

    # confirm before doing hard resets
    if [[ "$1" == "reset" ]] && [[ "$2" == "--hard" ]]; then
        confirm=1
    fi

    if [[ "$1" == "push" ]] && [[ "$2" == "-f" ]]; then
        confirm=1
    fi

    if [[ "$1" == "clean" ]] && [[ "$2" == "-fd" ]]; then
        confirm=1
    fi

    if [[ $confirm -eq 1 ]]; then
        echo "Are you being retarded? Press any key to continue..."
        read -sk1
        echo ""
    fi

    command git $@
}

function git-checkout-date () {
    date_input=$1
    time_input=${2:-00:00:00}
    branch_input=${3:-main}

    if [[ "$date_input" == "" ]]; then
        echo "git-checkout-date <date> [time] [branch]"
        return 1
    fi

    git checkout "${branch}@{${date_input} ${time_input}}"
}

function docker() {
    if [[ "$1" == "kill-all" || "$1" == "stop-all" ]]; then
        containers=($(docker ps -q))
        if [[ "$containers" == "" ]]; then
            echo "Nothing to stop"
            return 1
        fi

        command docker kill $containers
        return
    fi

    if [[ "$1" == "rm-all" ]]; then
        command docker ps --filter status=exited -q | xargs docker rm
        return
    fi

    command docker $@
}

function frm() {
    CUR=$(pwd)
    FILENAME=$(uuidgen)

    cd ~/P/frame && go build -o /tmp/$FILENAME frame.go

    EXIT_CODE=$?

    cd $CUR

    if [[ $EXIT_CODE -gt 0 ]]; then
        return $EXIT_CODE
    fi

    /tmp/./$FILENAME $@
}

alias vi="nvim --clean"
alias vim="nvim"
alias gom="go mod tidy && go mod vendor"
alias task="go-task"
alias k="kubectl"
alias kx="kubectx"

# Work
alias ert="~/R/ertia/ertia"
