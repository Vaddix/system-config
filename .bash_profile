echo "Executing ~/.bash_profile"

PIP3PATH=$(which pip3)
EMAIL="doluwole@fetchpackage.com"
export PATH=$PATH:$PIP3PATH
eval "$(/opt/homebrew/bin/brew shellenv)"
source ~/.color_my_prompt.sh
source ~/.git-prompt.sh
source ~/.git-completion.sh
export CODEBASE=~/Documents/Codebase
alias ll='ls -al'
alias hermes='cd $CODEBASE/hermes'
alias codebase='cd $CODEBASE'

alias dClean='docker rm -f $(docker ps -a -q); docker volume rm $(docker volume ls -q)'
alias dReset='docker-compose down && docker rm -f $(docker ps -a -q); docker volume rm $(docker volume ls -q); docker-compose build --no-cache && docker-compose up & > ~/docker.log'

dockerReset() {

docker-compose down
echo
echo "docker containers shut down"
echo

echo "docker rm -f $(docker ps -a -q)"
docker rm -f $(docker ps -a -q)
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
alias cleandockerimg='docker image rm $(docker image ls | grep 4.8 | grep none | grep -o "[a-f0-9]\{12\}")'
alias cleandockercont='docker rm $(docker ps -a | grep Exited | grep -o "[a-f0-9]\{12\}")'
alias buildRunLoggingX='cleandockerimg ; docker build -q -t label-automated-logging-dev --cache-from=label-automated-logging-dev . && docker run -it --env-file loggingx/.env.local_docker --rm --network hermes_default --name loggingx loggingx'
