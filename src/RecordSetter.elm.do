#!/usr/bin/env nu

let deps = glob **/*.elm --exclude [RecordSetter.elm] | path relative-to $env.PWD
redo-ifchange ...$deps ../elm.json
npx setem --stdout ..
