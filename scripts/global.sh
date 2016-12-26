#!/usr/bin/env bash

echo "running global script"

if [ "${kind}" ]; then
  echo "node ${HOSTNAME%%.*} is ${kind}"
fi
