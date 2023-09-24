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


undefinedCard : CardDef
undefinedCard =
    mkCardDef { default | name = "未実装カード" } identity


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
            { default | name = "防御", block = 5, mana = 1, attackTimes = 0 }
    in
    mkCardDef n (s_block 8)


bash : CardDef
bash =
    let
        n =
            { default | name = "強打", attack = 8, mana = 2, vulnerable = 2 }
    in
    mkCardDef n (s_attack 10 >> s_vulnerable 3)


anger : CardDef
anger =
    let
        n =
            { default | name = "怒り", attack = 6 }
    in
    mkCardDef n (s_attack 8)


feed : CardDef
feed =
    let
        n =
            { default | name = "捕食", attack = 10, mana = 1 }
    in
    mkCardDef n (s_attack 12)


headButt : CardDef
headButt =
    let
        n =
            { default | name = "ヘッドバット", attack = 9, mana = 1 }
    in
    mkCardDef n (s_attack 12)


trueGrit : CardDef
trueGrit =
    let
        n =
            { default | name = "不屈の闘志", block = 7, mana = 1, attackTimes = 0 }
    in
    mkCardDef n (s_block 9)



-- flex : CardDef
-- flex =
--     let
--         n =
--             { default | name = "フレックス", mana = 0, strength = 2 }
--     in
--     mkCardDef n (s_strength 2)


shrugItOff : CardDef
shrugItOff =
    let
        n =
            { default | name = "受け流し", block = 8, mana = 1, draw = 1, attackTimes = 0 }
    in
    mkCardDef n (s_block 11)


ranpage : CardDef
ranpage =
    let
        n =
            { default | name = "ランページ", attack = 8, mana = 1 }
    in
    mkCardDef n identity


cleave : CardDef
cleave =
    let
        n =
            { default | name = "なぎ払い", attack = 8, mana = 1 }
    in
    mkCardDef n (s_attack 11)


thunderClap : CardDef
thunderClap =
    let
        n =
            { default | name = "サンダークラップ", attack = 4, mana = 1, vulnerable = 1 }
    in
    mkCardDef n (s_attack 7)


ghostArmor : CardDef
ghostArmor =
    let
        n =
            { default | name = "ゴーストアーマー", block = 10, mana = 1, attackTimes = 0 }
    in
    mkCardDef n (s_block 13)


hemokinesis : CardDef
hemokinesis =
    let
        n =
            { default | name = "ヘモキネシス", attack = 15, mana = 1, block = -2 }
    in
    mkCardDef n (s_attack 20)


twinStrike : CardDef
twinStrike =
    let
        n =
            { default | name = "ツインストライク", attack = 5, attackTimes = 2, mana = 1 }
    in
    mkCardDef n (s_attack 7)


pommelStrike : CardDef
pommelStrike =
    let
        n =
            { default | name = "ポンメルストライク", attack = 9, draw = 1, mana = 1 }
    in
    mkCardDef n (s_attack 10 >> s_draw 2)


offering : CardDef
offering =
    let
        n =
            { default | name = "供物", mana = -2, draw = 3, block = -6 }
    in
    mkCardDef n (s_draw 5)


heavyBlade : CardDef
heavyBlade =
    let
        n =
            { default | name = "ヘビーブレード", attack = 14 / 3, attackTimes = 3, mana = 2 }
    in
    mkCardDef n (s_attack (14 / 5) >> s_attackTimes 5)


possibleCardDefs : List CardDef
possibleCardDefs =
    [ undefinedCard, anger, feed, headButt, trueGrit, shrugItOff, ranpage, cleave, thunderClap, ghostArmor, hemokinesis, twinStrike, pommelStrike, offering ]


possibleCards : List Card
possibleCards =
    possibleCardDefs
        |> List.map .normal


allCardDefs : List CardDef
allCardDefs =
    [ strike, guard, bash ] ++ possibleCardDefs


upgrade : Card -> Card
upgrade card =
    List.filter (\def -> def.normal.name == card.name) allCardDefs
        |> List.head
        |> Maybe.map .plus
        |> Maybe.withDefault card


view : Card -> Html msg
view card =
    div [ css [] ] [ text <| .name card ]
