zstyle :omz:plugins:ssh-agent identities ~/.ssh/id_ed25519 ~/.ssh/keys/{github_personal,bitbucket_mpk}
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
        # Prevent CTRL-D on dropdown terminals
        setopt IGNORE_EOF
        function exit() {
            if [[ "$1" == "-f" ]]; then
                builtin exit
            fi
            echo "You should not exit a dropdown terminal!"
            echo "Use restart-dropdown-terminals to restart terminals"
            printf "Use \\\exit to force exit\n"
            return 1
        }
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

    if [[ "$1" == "clean" ]] && [[ "$2" == "-f" ]] || [[ "$2" == "-fd" ]]; then
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
    default_branch=$(git branch --show-current)
    if [[ "$default_branch" == "" ]]; then
        default_branch="main"
    fi

    date_input=$1
    time_input=${2:-00:00}
    branch_input=${3:-$default_branch}

    git checkout `git rev-list -n 1 --first-parent --before="$date_input $time_input" $branch_input`
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

# Start a temp docker container with the given entrypoint
function drun() {
    image=$1
    entrypoint=${2:-sh}
    if [[ "$image" == "" ]]; then
        echo "drun [IMAGE] [ENTRYPOINT]"
        return 1
    fi
    command docker run -it --rm --entrypoint $entrypoint $image
}

# Attach to a running docker container with the given entrypoint
function dattach() {
    container=$1
    entrypoint=${2:-sh}
    if [[ "$container" == "" ]]; then
        echo "dattach [CONTAINER] [ENTRYPOINT]"
        return 1
    fi

    command docker exec -it $container $entrypoint
}

# Attach to a running k8s pod with the given entrypoint
function kattach() {
    namespace=$1
    pod=$2

    if [[ "$namespace" == "" ]] || [[ "$pod" == "" ]]; then
        echo "kattach [NAMESPACE] [POD] [ENTRYPOINT]"
        return 1
    fi

    entrypoint=${3:-sh}
    kubectl exec --stdin --tty -n $namespace $pod -- $entrypoint
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

function make() {
    if [[ -f "./Earthfile" ]]; then
        print "\033[1;33mEarthfile detected, switching to earthly\033[0m\n"
        ~/.local/bin/earthly $@
        return
    fi
    command make $@
}

alias vi="nvim --clean"
alias vim="nvim"
alias gom="go mod tidy && go mod vendor"
alias task="go-task"
alias k="kubectl"
alias kx="kubectx"
alias fsize="du -a 2>/dev/null | sort -n"

# Work
alias ertdev="~/R/ertia/cli/ertia"
alias ertia02="ertia ertia02"
alias ertia03="ertia ertia03"
alias aws="docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli"
