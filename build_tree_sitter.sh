#!/bin/bash

lang=$1
org="tree-sitter"

if [ "${lang}" == "elixir" ]
then
    org="elixir-lang"
fi

if [ "${lang}" == "heex" ]
then
    org="phoenixframework"
fi

soext="so"

echo "Building ${lang}"

# Retrieve sources.
git clone --depth 1 --quiet "https://github.com/${org}/tree-sitter-${lang}.git" 

if [ "${lang}" == "typescript" ]
then
    lang="typescript/tsx"
fi
cd "tree-sitter-${lang}/src"

if [ "${lang}" == "typescript/tsx" ]
then
    lang="tsx"
fi

# Build.
cc -c -I. parser.c
# Compile scanner.c.
if test -f scanner.c
then
    cc -fPIC -c -I. scanner.c
fi
# Compile scanner.cc.
if test -f scanner.cc
then
    c++ -fPIC -I. -c scanner.cc
fi
# Link.
if test -f scanner.cc
then
    c++ -fPIC -shared *.o -o "libtree-sitter-${lang}.${soext}"
else
    cc -fPIC -shared *.o -o "libtree-sitter-${lang}.${soext}"
fi

# Copy out.

if [ "${lang}" == "tsx" ]
then
    cp "libtree-sitter-${lang}.${soext}" ..
    cd ..
fi

mkdir -p ../../dist
cp "libtree-sitter-${lang}.${soext}" ../../dist
cd ../../
if [ "${lang}" == "tsx" ]
then
    rm -rf "tree-sitter-typescript"
else
    rm -rf "tree-sitter-${lang}"
fi
