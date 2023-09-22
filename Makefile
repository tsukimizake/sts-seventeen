.PHONY: setem start

setem: 
	rm src/RecordSetter.elm
	setem src/
	mv RecordSetter.elm src/


start: 
	elm-watch hot
	open build/sts-seventeen.html
