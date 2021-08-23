#!/bin/bash

set -eu -o pipefail

function usage() {
  echo -e "\nUsage: $0 [-d 256|384|512] file"
  echo -e "\nCalculates and prints an appropriate string for HTML link integrity attribute for the input file"
  echo -e "Expects 1 or 2 arguments."
  echo -e "\nOptions:"
  echo -e "  -d\tSpecify the digest value.  Allowed values are 256, 384, 512.  Defaults to 512."
  echo -e "  -h\tPrint this help."
}

UP="\033[1A"      #Move Cursor UP
EF="\033[0K"      #Erase Forward
GN="\033[01;32m"  #Set Colour Green
RD="\033[01;31m"  #Set Colour Red
GY="\033[00;36m"  #Set Colour Grey
NC="\033[00m"     #Set No Colour
WH="\033[01;37m"  #Set Colour White
newLine=$'\n'


_V=0
_INDENT=10#0
_OLDINDENT=10#0
function log () {
    if [[ $_V -eq 1 ]]; then
      if [[ -n "$_INDENT" ]] && [[ -n "$_OLDINDENT" ]]; then
        if [[ "$_INDENT" -ne "$_OLDINDENT" ]]; then
          echo ""
        fi
        for (( i = 0; i < $_INDENT; i++ )); do
          echo -n "  "
        done
      fi
      echo -e "${GY}$@${NC}"
      _OLDINDENT="$_INDENT"
    fi
}


allowedDigestValues=("256" "384" "512")


_DIGEST=512

# if ! ([[ $# -eq 2 ]] || [[ $# -eq 1 ]])
# then
#   echo -e "Number of arguments: $#.\nExpected 1 or 2."
#   usage
# else
#   echo "Number of arguments: $#"
# fi

varsArray=()
while getopts "vhd:" option
do
  case $option in
    v)  _V=1
    ;;

    d)  if [[ " ${allowedDigestValues[@]} " =~ " $OPTARG " ]]
        then
          _DIGEST=$OPTARG
        else
          echo -e "Error: digest must be one of 256, 384, 512.  Defaults to 512"
          usage
          exit 1
        fi
    ;;

    h)  usage
        exit 0
    ;;

    ?)  usage
        exit 1
    ;;
  esac

done
shift $((OPTIND -1))

log "_DIGEST=$_DIGEST"

echo "Number of arguments: $#"