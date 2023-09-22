module History exposing (..)


type alias History a =
    List a


init : a -> History a
init a =
    [ a ]


push : a -> History a -> History a
push a his =
    a :: his


pop : History a -> History a
pop his =
    List.drop 1 his


newest : a -> History a -> a
newest default his =
    List.head his
        |> Maybe.withDefault default


length : History a -> Int
length =
    List.length
