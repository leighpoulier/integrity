#!/bin/bash

set -eu -o pipefail

function usage() {
  echo -e "Usage: $0 [-d 256|384|512] file [file]..."
  echo -e "\nCalculates and prints an appropriate string for HTML link integrity attribute for the input file"
  echo -e "\nOptions:"
  echo -e "  -d\tSpecify the digest value.  Allowed values are 256, 384, 512.  Defaults to 512."
  echo -e "  -h\tPrint this help."
}

RD="\033[01;31m"
NC="\033[00m"

_V=0
function log () {
    if [[ $_V -eq 1 ]]; then
      echo -e "$@"
    fi
}

allowedDigestValues=("256" "384" "512")
_DIGEST=512

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

if ! command -v shasum &> /dev/null
then
    echo "shasum could not be found"
    exit 1
fi
if ! command -v awk &> /dev/null
then
    echo "awk could not be found"
    exit 1
fi
if ! command -v xxd &> /dev/null
then
    echo "xxd could not be found"
    exit 1
fi
if ! command -v base64 &> /dev/null
then
    echo "base64 could not be found"
    exit 1
fi

log "_DIGEST=$_DIGEST"
log "Number of arguments: $#"

if [[ $@ -gt 0 ]]
then
  for file in "$@"
  do
    echo -e "\nFile: $file"
    hash="$(shasum -b -a $_DIGEST "$file" | awk '{print $1}' | xxd -r -p | base64 -w0)"
    echo "sha${_DIGEST}-${hash}"
    echo "integrity=\"sha${_DIGEST}-${hash}\""
    echo "<link rel=\"stylesheet\" href=\"$file\" integrity=\"sha${_DIGEST}-${hash}\">"
  done
else
  echo -e "${RD}Error: No file given to create hash${NC}\n"
  usage
  exit 1
fi