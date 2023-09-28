setem: 
    redo-ifchange src/RecordSetter.elm 
setup:
	npm install elm elm-watch
format:
	npx elm-format src/ --yes
start: 
	npx elm-watch hot
	open build/sts-seventeen.html
publish:
  just format
  npx elm make --optimize --output=index.html src/Main.elm
