#!/bin/bash

set -eu

function usage() {
  echo -e "\nUsage: $0 [-d 256|384|512] file"
  echo -e "\nCalculates and prints an appropriate string for HTML link integrity attribute for the input file"
  echo -e "Expects 1 or 2 arguments."
  echo -e "\nOptions:"
  echo -e "  -d, --digest\tSpecify the digest value.  Allowed values are 256, 384, 512.  Defaults to 512."
  echo -e "  -h, --help\tPrint this help."
}




if ! ([[ $# -eq 2 ]] || [[ $# -eq 1 ]])
then
  echo -e "Number of arguments: $#.\nExpected 1 or 2."
  usage
else
  echo "Number of arguments: $#"
fi

