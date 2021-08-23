#!/bin/bash

set -eu

function usage() {
  echo -e "\nUsage: $0 [-d 256|384|512] file"
  echo -e "\n\tCalculates and prints an appropriate string for HTML link integrity attribute for the input file"
  echo -e "\tExpects one or two arguments."
  echo -e "\n\t-a\tSpecify the digest value.  Allowed values are 256, 384, 512.  Defaults to 512"
  echo -e "\tIf -a is not given, defaults to 512."
}



echo "Number of arguments: $#"

if ! [[ $# -eq 2 ]]
then
  usage
else
  echo "$# equals 2"
fi

