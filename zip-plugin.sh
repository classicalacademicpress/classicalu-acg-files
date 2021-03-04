#!/bin/bash

DIR="classicalu-acg-files"

if [ -d "../$DIR" ]; then
  cd ../ && zip -r $DIR/classicalu-acg-files.zip $DIR \
    -x "${DIR}/.git/*" \
    -x "${DIR}/classicalu-acg-files.zip" \
    -x "${DIR}/node_modules/*" \
    -x "${DIR}/assets/elm-stuff/*" \
    -x "${DIR}/assets/node_modules/*"
else
  echo "ERROR"
  echo "Please rename project dir to:"
  echo $DIR
fi
