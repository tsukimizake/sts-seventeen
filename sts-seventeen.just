
setem: 
    redo-ifchange -s src/RecordSetter.elm 
start: 
	elm-watch hot
	open build/sts-seventeen.html
