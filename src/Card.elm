module Card exposing (Card(..), CardDef, CardStats, default, evaluate, isAttack, name, view)

import Html.Styled exposing (Html, div, text)
import Html.Styled.Attributes exposing (css)


type alias CardDef =
    { normal : Card
    , plus : Card
    }


type alias CardStats =
    { name : String
    , block : Int
    , attack : Float
    , attackTimes : Int
    , mana : Int
    , draw : Int
    , vulnerable : Int
    , weak : Int
    , strength : Int
    }


type Card
    = SimpleCard CardStats
    | ComplexCard (List Card -> CardStats)


default : CardStats
default =
    { name = ""
    , block = 0
    , attack = 0
    , attackTimes = 1
    , mana = 0
    , draw = 0
    , vulnerable = 0
    , weak = 0
    , strength = 0
    }


cardBase_internal : Card -> CardStats
cardBase_internal c =
    case c of
        SimpleCard s ->
            s

        ComplexCard effect ->
            -- 性能は出ない
            effect []


evaluate : List Card -> Card -> CardStats
evaluate deck c =
    case c of
        SimpleCard s ->
            s

        ComplexCard effect ->
            effect deck


name : Card -> String
name c =
    (cardBase_internal c).name


isAttack : Card -> Bool
isAttack c =
    (cardBase_internal c).attackTimes /= 0


view : Card -> Html msg
view card =
    div [ css [] ] [ text <| name card ]
