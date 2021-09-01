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
    echo "${RD}Error: shasum could not be found${NC}"
    echo "This script requires the following to be installed: shasum awk xxd base64"
    exit 1
fi
if ! command -v awk &> /dev/null
then
    echo "${RD}Error: awk could not be found${NC}"
    echo "This script requires the following to be installed: shasum awk xxd base64"
    exit 1
fi
if ! command -v xxd &> /dev/null
then
    echo "${RD}Error: xxd could not be found${NC}"
    echo "This script requires the following to be installed: shasum awk xxd base64"
    exit 1
fi
if ! command -v base64 &> /dev/null
then
    echo "${RD}Error: base64 could not be found${NC}"
    echo "This script requires the following to be installed: shasum awk xxd base64"
    exit 1
fi

log "_DIGEST=$_DIGEST"
log "Number of arguments: $#"

if [[ $# -gt 0 ]]
then
  for file in "$@"
  do
    if [[ -f "$file" ]]
    then
      echo -e "\nFile: $file"
      hash="$(shasum -b -a $_DIGEST "$file" | awk '{print $1}' | xxd -r -p | base64 -w0)"
      echo -e "\nBasic hash:"
      echo "sha${_DIGEST}-${hash}"
      echo -e "\nIntegrity attribute:"
      echo "integrity=\"sha${_DIGEST}-${hash}\""
      if [[ "${file##*.}" == "css" ]]
      then
        echo -e "\nFull link for css"
        echo "<link rel=\"stylesheet\" type="text/css" href=\"$file\" integrity=\"sha${_DIGEST}-${hash}\">"
      else
        if [[ "${file##*.}" == "js" ]]
        then
          echo -e "\nFull link for js:"
          echo "<script type=\"text/javascript\" src=\"$file\" integrity=\"sha${_DIGEST}-${hash}\"></script>"
        fi
      fi
    else
      echo -e "\n${RD}Error: $file is not a normal file${NC}\n"
    fi
  done
else
  echo -e "${RD}Error: No files given to create hash${NC}\n"
  usage
  exit 1
fi