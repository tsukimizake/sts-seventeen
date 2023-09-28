module Card exposing (..)


type alias CardDef =
    { normal : Card
    , plus : Card
    }


type alias Card =
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


default : Card
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
