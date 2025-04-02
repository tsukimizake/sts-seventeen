setem: 
    redo-ifchange src/RecordSetter.elm 
setup:
        npm install elm elm-watch
format:
        npx elm-format src/ --yes
start: 
        npx elm-watch hot & npx live-server --port=50993 --host=0.0.0.0 --no-browser
publish:
  just format
  npx elm make --optimize --output=index.html src/Main.elm
serve:
  npx live-server --port=50993 --host=0.0.0.0 --no-browser
dev:
  just publish
  just serve
