module Card exposing (..)


type alias CardDef =
    { normal : Card
    , plus : Card
    }


type alias Card =
    { name : String
    , guard : Int
    , attack : Int
    , attackTimes : Int
    , mana : Int
    , draw : Int
    , vulnerable : Int
    , strength : Int
    }


default : Card
default =
    { name = ""
    , guard = 0
    , attack = 0
    , attackTimes = 1
    , mana = 0
    , draw = 0
    , vulnerable = 0
    , strength = 0
    }
