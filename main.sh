#!/usr/bin/env bash

shopt -s extglob

function random()
{
  local -i low="$1"
  local -i high="$2"

  if (( low > high ))
  then
    low=high
  fi

  echo "$((low + RANDOM % (high - low + 1)))"
}

function randomSequence()
{
  local -i count="$1"
  local -i low="$2"
  local -i high="$3"

  for (( i = 0; i < count; i++ ))
  do
    echo -n "$(random "$low" "$high") "
  done
  echo
}

# shellcheck disable=SC2207
array=($(randomSequence 10 -10 10))
echo "Array is: ${array[*]}"
echo "First positive item is: $(printf "%s\n" "${array[@]}" | sed -n -E -e '/^[[:digit:]]$/ p' | sort -g | head -n 1)"
echo "Last negative item is: $(printf "%s\n" "${array[@]}" | sed -n -E -e '/^-[[:digit:]]$/ p' | sort -g | tail -n 1)"
