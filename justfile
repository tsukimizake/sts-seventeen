set shell := ["nu", "-c"]

setem:
    redo-ifchange src/RecordSetter.elm 

setup:
    npm install elm elm-watch

format:
    npx elm-format src/ --yes
    just --fmt --unstable

start:
    npx elm-watch hot 

browse:
    ^open http://localhost:8101/
