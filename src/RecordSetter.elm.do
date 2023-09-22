#!/bin/env bash
exec >&2

shopt -s extglob
redo-ifchange !(RecordSetter).elm

setem --output /tmp ..
mv /tmp/RecordSetter.elm $3
