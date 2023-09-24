setem: 
    redo-ifchange src/RecordSetter.elm 
setup:
	npm install elm elm-watch
start: 
	npx elm-watch hot
	open build/sts-seventeen.html
