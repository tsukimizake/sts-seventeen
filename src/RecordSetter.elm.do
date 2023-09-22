exec >&2
#!/bin/env bash

shopt -s extglob
# redo-ifchange !(RecordSetter).elm

setem --output /tmp ..
mv /tmp/RecordSetter.elm $3
