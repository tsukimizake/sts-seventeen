setem: 
    redo-ifchange src/RecordSetter.elm 
setup:
	npm install elm elm-watch
start: 
	npx elm-watch hot
	open build/sts-seventeen.html
publish:
  npx elm make --optimize --output=index.html src/Main.elm
