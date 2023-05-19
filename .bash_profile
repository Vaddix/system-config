echo "Executing ~/.bash_profile"

PIP3PATH=$(which pip3)
EMAIL="doluwole@fetchpackage.com"
export PATH=$PATH:$PIP3PATH
eval "$(/opt/homebrew/bin/brew shellenv)"
#export GIT_PS1_SHOWUPSTREAM=auto
#export GIT_PS1_SHOWDIRTYSTATE=true
#export GIT_PS1_SHOWSTASHSTATE=true
#export PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'
export OLD_PS1=$PS1
source ~/.color_my_prompt.sh
source ~/.git-prompt.sh
source ~/.git-completion.sh
export CODEBASE=~/Documents/Codebase
alias ll='ls -al'
alias hermes='cd $CODEBASE/hermes'
alias codebase='cd $CODEBASE'

alias dClean='docker rm -f $(docker ps -a -q); docker volume rm $(docker volume ls -q)'
alias dReset='docker-compose down --rmi all; docker-compose build --no-cache && docker-compose up & > ~/docker.log'

dockerReset() {

docker-compose down
echo
echo "docker containers shut down"
echo

echo "docker rm $(docker ps -a -q)"
docker rm $(docker ps -a -q)
echo
echo "docker containers removed"
echo

echo "docker volume rm $(docker volume ls -q)"
docker volume rm $(docker volume ls -q)
echo
echo "docker volumes removed"
echo

echo "docker-compose build --no-cache"
docker-compose build --no-cache
echo
echo "docker containers rebuilt sans cache"
echo

echo "docker-compose up & > ~/docker.log"
docker-compose up & > ~/docker.log
echo
echo "docker containers are running"
echo
}
alias cleandockerimg='docker image rm $(docker image ls | grep 1.4 | grep none | grep -o "[a-f0-9]\{12\}")'
alias cleandockercont='docker rm $(docker ps -a | grep Exited | grep -o "[a-f0-9]\{12\}")'
alias buildRunLoggingX='cleandockerimg ; docker build -q -t label-automated-logging-dev --cache-from=label-automated-logging-dev . && docker run -it --env-file loggingx/.env.local_docker --rm --network hermes_default --name loggingx loggingx'

alias clipboardToBase64="pbpaste | tr '[:upper:]' '[:lower:]' | sed 's/@/-/' | sed 's/\n//' | base64 | tr -d '\n' | pbcopy"
alias dockerlogin='aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 173267925316.dkr.ecr.us-east-1.amazonaws.com'
alias dRez='docker compose down && docker compose up -d'

function run_remote_regression {
  ssh -i ~/.ssh/alw-live-regression.pem $1 "cd label-automated-logging && screen 'source setup_env.sh && python test_regression/setup && python run_regression_test_live.py && exit' && exit"
  sftp -i ~/.ssh/alw-live-regression.pem -b - $1 "get label-automated-logging/parsed_results.json"
  ssh -i ~/.ssh/alw-live-regression.pem $1 "sudo shutdown now" 
}

function remote_run_regression_script {
  ssh -i ~/.ssh/alw-live-regression.pem $1 "screen -S regression_run -dm /home/ubuntu/run_regression_and_exit.sh" 
  ssh -i ~/.ssh/alw-live-regression.pem $1 "sudo shutdown +120" 
}

function regression-get {
  sftp -i ~/.ssh/alw-live-regression.pem $1
}

function regression-get-results {
  sftp -i ~/.ssh/alw-live-regression.pem $1:/home/ubuntu/label-automated-logging/parsed_results.json
}

function regression_kill {
  ssh -i ~/.ssh/alw-live-regression.pem $1 "sudo shutdown now"
}

function regression_connect {
  ssh -i ~/.ssh/alw-live-regression.pem $1
}

function regression_reconnect {
  ssh -i ~/.ssh/alw-live-regression.pem $1 "screen -r"
}

function gitpupstream {
 git pull --set-upstream origin/$1 $1
}
