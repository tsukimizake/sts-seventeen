#!/bin/env bash
set -euo pipefail
exec >&2

shopt -s extglob
redo-ifchange !(RecordSetter).elm
redo-ifchange **/*.elm
redo-ifchange ../elm.json

setem --output /tmp ..
mv /tmp/RecordSetter.elm $3
