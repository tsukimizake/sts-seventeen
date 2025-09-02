set shell := ["nu", "-c"]

setem: 
    redo-ifchange src/RecordSetter.elm 
setup:
	npm install elm elm-watch
format:
	npx elm-format src/ --yes
start: 
	npx elm-watch hot
publish:
  just format
  npx elm make --optimize --output=index.html src/Main.elm
  ^open index.html
