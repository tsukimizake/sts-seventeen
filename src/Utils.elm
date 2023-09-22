module Utils exposing (..)


noCmd : model -> ( model, Cmd msg )
noCmd m =
    ( m, Cmd.none )
