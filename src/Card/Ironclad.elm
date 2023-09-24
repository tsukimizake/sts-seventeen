module Card.Ironclad exposing (..)

import Card exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import RecordSetter exposing (..)


mkCardDef : Card -> (Card -> Card) -> CardDef
mkCardDef card f =
    let
        plus =
            f card
                |> s_name (card.name ++ "+")
    in
    CardDef card plus


strike : CardDef
strike =
    let
        n =
            { default | name = "ストライク", attack = 6, mana = 1 }
    in
    mkCardDef n (s_attack 9)


guard : CardDef
guard =
    let
        n =
            { default | name = "防御", guard = 5, mana = 1 }
    in
    mkCardDef n (s_guard 8)


bash : CardDef
bash =
    let
        n =
            { default | name = "強打", attack = 8, mana = 2, vulnerable = 2 }
    in
    mkCardDef n (s_attack 11)


anger : CardDef
anger =
    let
        n =
            { default | name = "怒り", attack = 6 }
    in
    mkCardDef n (s_attack 8)


upgrade : Card -> Card
upgrade card =
    let
        defs =
            [ strike, guard, bash, anger ]
    in
    List.filter (\def -> def.normal.name == card.name) defs
        |> List.head
        |> Maybe.map .plus
        |> Maybe.withDefault card


view : Card -> Html msg
view card =
    div [ css [] ] [ text <| .name card ]
