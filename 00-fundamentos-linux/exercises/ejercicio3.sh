#!/bin/bash

TEXT_FOR_EMPTY_VALUE='Que me gusta la bash!!!!'
read -p "Texto: " TEXT

if [[ -z "$TEXT" ]]; then
  TEXT=$TEXT_FOR_EMPTY_VALUE
fi

# Paso 1
mkdir -p foo/dummy
echo $TEXT > foo/dummy/file1.txt
touch foo/dummy/file2.txt
mkdir -p foo/empty

# Paso 2
cat foo/dummy/file1.txt > foo/dummy/file2.txt
mv foo/dummy/file2.txt foo/empty/