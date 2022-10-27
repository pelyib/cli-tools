#!/usr/bin/env bash

length="${1:-10}"

for (( i = 1; i <= "${length}"; i++ ))
do
  UUID=$(uuidgen)
  UUID_WITHOUT_DASH=${UUID//-/}
  echo "${UUID} => ${UUID_WITHOUT_DASH} => unhex('${UUID_WITHOUT_DASH}')"
done
