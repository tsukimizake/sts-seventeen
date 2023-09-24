module Card.Ironclad exposing (..)

import AssocList
import Card exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)


strike : Card
strike =
    { default | name = "ストライク", attack = 6, mana = 1 }


strikeP : Card
strikeP =
    { strike | name = "ストライク+", attack = 9 }


guard : Card
guard =
    { default | name = "防御", guard = 5, mana = 1 }


bash : Card
bash =
    { default | name = "強打", attack = 8, mana = 2, vulnerable = 2 }


anger : Card
anger =
    { default | name = "怒り", attack = 6 }


angerP : Card
angerP =
    { anger | name = "怒り+", attack = 8 }


view : Card -> Html msg
view card =
    div [ css [] ] [ text <| .name card ]


upgrade : Card -> Card
upgrade card =
    let
        ugMap =
            AssocList.fromList [ ( strike, strikeP ), ( anger, angerP ) ]
    in
    AssocList.get card ugMap
        |> Maybe.withDefault card
