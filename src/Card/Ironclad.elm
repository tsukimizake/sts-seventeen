module Card.Ironclad exposing (..)

import Card exposing (..)
import RecordSetter exposing (..)


mkCardDef : CardStats -> (CardStats -> CardStats) -> CardDef
mkCardDef card f =
    let
        plus =
            f card
                |> s_name (card.name ++ "+")
    in
    CardDef (SimpleCard card) (SimpleCard plus)


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
            { default | name = "供物", mana = -2, draw = 3, block = -6, attackTimes = 0 }
    in
    mkCardDef n (s_draw 5)


heavyBlade : CardDef
heavyBlade =
    let
        n =
            { default | name = "ヘビーブレード", attack = 14 / 3, attackTimes = 3, mana = 2 }
    in
    mkCardDef n (s_attack (14 / 5) >> s_attackTimes 5)


flameBarrier : CardDef
flameBarrier =
    let
        n =
            { default | name = "炎の障壁", block = 12, mana = 2, attackTimes = 0 }
    in
    mkCardDef n (s_block 16)


immovable : CardDef
immovable =
    let
        n =
            { default | name = "不動", block = 30, mana = 2, attackTimes = 0 }
    in
    mkCardDef n (s_block 40)


warCry : CardDef
warCry =
    let
        n =
            { default | name = "雄叫び", mana = 0, draw = 1, attackTimes = 0 }
    in
    mkCardDef n (s_draw 2)


severSoul : CardDef
severSoul =
    let
        n =
            { default | name = "霊魂切断", attack = 16, mana = 2 }
    in
    mkCardDef n (s_attack 22)


seeingRed : CardDef
seeingRed =
    let
        n =
            { default | name = "激昂", mana = -1, attackTimes = 0 }
    in
    mkCardDef n (s_mana -2)


immolate : CardDef
immolate =
    let
        n =
            { default | name = "焼身", attack = 21, mana = 2 }
    in
    mkCardDef n (s_attack 28)


carnage : CardDef
carnage =
    let
        n =
            { default | name = "大虐殺", attack = 20, mana = 2 }
    in
    mkCardDef n (s_attack 28)


buldegeon : CardDef
buldegeon =
    let
        n =
            { default | name = "脳天割り", attack = 32, mana = 3 }
    in
    mkCardDef n (s_attack 42)


wildStrike : CardDef
wildStrike =
    let
        n =
            { default | name = "乱打", attack = 12, mana = 1, draw = -1 }
    in
    mkCardDef n (s_attack 17)


bloodLetting : CardDef
bloodLetting =
    let
        n =
            { default | name = "瀉血", attackTimes = 0, mana = -2 }
    in
    mkCardDef n (s_mana -3)


burningPact : CardDef
burningPact =
    let
        n =
            { default | name = "焦熱の契約", mana = 0, draw = 2, attackTimes = 0 }
    in
    mkCardDef n (s_draw 3)


clothesline : CardDef
clothesline =
    let
        n =
            { default | name = "ラリアット", attack = 12, weak = 2, mana = 2 }
    in
    mkCardDef n (s_attack 14 >> s_weak 3)


upperCut : CardDef
upperCut =
    let
        n =
            { default | name = "アッパーカット", attack = 13, vulnerable = 1, weak = 1, mana = 2 }
    in
    mkCardDef n (s_vulnerable 2 >> s_weak 2)


secondWind : CardDef
secondWind =
    let
        effect rate name deck =
            let
                skillsInDeck =
                    deck
                        |> List.filter (isAttack >> not)
                        |> List.length

                cardCount =
                    List.length deck

                drawSum =
                    deck
                        |> List.map (evaluate [])
                        |> List.map .draw
                        |> List.sum

                loopTurn =
                    toFloat (cardCount - drawSum) / 5

                drawPerTurn =
                    if loopTurn > 0 then
                        toFloat cardCount / loopTurn

                    else
                        10

                block =
                    if cardCount > 0 && loopTurn > 0 then
                        round ((toFloat skillsInDeck / toFloat cardCount) * drawPerTurn * toFloat rate)

                    else
                        -- should not happen
                        0
            in
            { default
                | name = name
                , mana = 1
                , attackTimes = 0
                , block = block
            }

        normal =
            ComplexCard (effect 5 "セカンドウィンド")

        plus =
            ComplexCard (effect 7 "セカンドウィンド+")
    in
    CardDef normal plus


possibleCardDefs : List CardDef
possibleCardDefs =
    [ undefinedCard, anger, feed, headButt, trueGrit, shrugItOff, ranpage, cleave, thunderClap, ghostArmor, hemokinesis, twinStrike, pommelStrike, offering, heavyBlade, flameBarrier, immovable, warCry, severSoul, seeingRed, immolate, carnage, buldegeon, wildStrike, bloodLetting, burningPact, clothesline, upperCut, secondWind ]



-- TODO 特殊カードメモ
-- パーフェクトストライク, 旋風人、武装、ボディスラム、クラッシュ、荒廃、バトルトランス、ドロップキック、塹壕、激怒、鬼火
-- 無理じゃねなやつ
-- 血には血を、武装解除、二刀流、内なる刃、燃えさかるブロー、見張り、衝撃波、ダブルタップ、発掘、死神
-- あと筋力とパワーは無視


possibleCards : List Card
possibleCards =
    possibleCardDefs
        |> List.map .normal


allCardDefs : List CardDef
allCardDefs =
    [ strike, guard, bash ] ++ possibleCardDefs


upgrade : Card -> Card
upgrade card =
    List.filter (\def -> name def.normal == name card) allCardDefs
        |> List.head
        |> Maybe.map .plus
        |> Maybe.withDefault card
