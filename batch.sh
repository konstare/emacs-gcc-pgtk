#!/bin/bash

languages=(
    'javascript'
    'c'
    'cpp'
    'css'
    'c-sharp'
    'java'
    'bash'
    'python'
    'typescript'
    'json'
    'dockerfile'
)

for language in "${languages[@]}"
do
    ./build.sh $language
done
