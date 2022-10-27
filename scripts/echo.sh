#!/bin/zsh

# https://en.wikipedia.org/wiki/ANSI_escape_code

RED='\033[37;41m'
YELLOW='\033[37;103m'
WHITE='\033[1;37m'
GREEN='\033[37;42m'
ORANGE='\033[37;45m'
NC='\033[0m' # No Color

# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
# continue from here
verbose_mode=false
message=""
for i in "$@"; do
  case $i in
    -v)
        verbose_mode=true
        ;;
    *)
        message=${i}
      ;;
  esac
done

function info() 
{
    echo -e "${GREEN}  INFO ${NC}|> ${1}"
}

function debug()
{
    echo -e "${ORANGE} DEBUG ${NC}|> ${1}"
}

function warning()
{
    echo -e "${YELLOW}WARNING${NC}|> ${1}"
}

function error()
{
    echo -e "${RED} ERROR ${NC}|> ${1}"
}