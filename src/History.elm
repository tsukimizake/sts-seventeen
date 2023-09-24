module History exposing (..)


type alias History a =
    ( a, List a )


init : a -> History a
init a =
    ( a, [] )


push : a -> History a -> History a
push a ( hd, his ) =
    ( a, hd :: his )


pop : History a -> History a
pop ( hd, his ) =
    case his of
        [] ->
            ( hd, [] )

        h :: t ->
            ( h, t )


newest : History a -> a
newest ( hd, _ ) =
    hd


length : History a -> Int
length ( _, his ) =
    List.length his + 1
