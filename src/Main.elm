module Main exposing (..)

import Browser
import Card exposing (Card)
import Card.Ironclad as Card
import Css exposing (..)
import History exposing (History)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, type_, value)
import Html.Styled.Events exposing (..)
import List.Extra
import RecordSetter exposing (..)
import StylesExtra exposing (gapByMargin)
import Utils exposing (..)


type alias Model =
    { history : History State }


type alias State =
    { cards : List Card
    , manaPerTurn : Float
    , strength : Float
    }


initialModel : Model
initialModel =
    { history =
        History.init <|
            { cards = initialCards
            , manaPerTurn = 3
            , strength = 0
            }
    }


initialCards : List Card
initialCards =
    List.repeat 5 Card.strike.normal ++ List.repeat 4 Card.guard.normal ++ [ Card.bash.normal ]


type Msg
    = AddCard Card
    | RemoveCard Int
    | UpgradeCard Int Card
    | RevertChange
    | UpdateMana (Maybe Float)
    | UpdateStrength (Maybe Float)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AddCard card ->
            model
                |> pushCardsHistory (\cards -> card :: cards)
                |> noCmd

        RemoveCard idx ->
            model
                |> pushCardsHistory (List.Extra.removeAt idx)
                |> noCmd

        UpgradeCard idx card ->
            model
                |> pushCardsHistory (\cards -> List.Extra.setAt idx (Card.upgrade card) cards)
                |> noCmd

        RevertChange ->
            model
                |> s_history (History.pop model.history)
                |> noCmd

        UpdateMana val ->
            model
                |> s_history (History.update (\state -> { state | manaPerTurn = val |> Maybe.withDefault 0 }) model.history)
                |> noCmd

        UpdateStrength val ->
            model
                |> s_history (History.update (\state -> { state | strength = val |> Maybe.withDefault 0 }) model.history)
                |> noCmd


pushCardsHistory : (List Card -> List Card) -> Model -> Model
pushCardsHistory f m =
    let
        newCards =
            (History.newest m.history).cards |> f
    in
    m.history
        |> History.push (s_cards newCards (History.newest m.history))
        |> putIn s_history m


view : Model -> List (Html Msg)
view m =
    [ div [ css [ gapByMargin 30 ] ]
        [ calcResult <| History.newest m.history
        , addCardForm m
        , removeCardForm m
        , currentCardList m
        , notes
        ]
    ]


notes : Html msg
notes =
    let
        lines =
            [ "*1 現状強打自体にも1.5倍がかかっていて大きめに出ています"
            , "本家17式と同様に1周目で大暴れできるデッキを作ることに着目しており、廃棄は考慮していません"
            , "筋力系のカードとパワーに関しては例外処理の遊園地みたいになるので実装しません。ユーザーが各計算ステップに補正値を入力できるようにすることでお茶を濁す予定"
            , "ヘモキネシスなどのHP減少はブロックの減少として表現しています"
            ]
    in
    div [] <|
        h2 [] [ text "以下注意書き" ]
            :: List.map (\line -> div [] [ text line ]) lines


currentCardList : Model -> Html Msg
currentCardList m =
    div []
        [ text "カード一覧"
        , div
            [ css
                [ display grid
                , gridTemplateColumns <| List.repeat 5 "1fr"
                , gridColumnGap (px 10)
                , gridRowGap (px 10)
                ]
            ]
            (m.history
                |> History.newest
                |> .cards
                |> List.indexedMap
                    (\idx card ->
                        div []
                            [ Card.view card
                            , div
                                [ css
                                    [ display grid
                                    , gridTemplateColumns [ "1fr", "1fr" ]
                                    , gridColumnGap (px 5)
                                    ]
                                ]
                                [ button [ onClick <| RemoveCard idx ] [ text "除去" ]
                                , if card.name |> String.endsWith "+" then
                                    noHtml

                                  else
                                    button [ onClick <| UpgradeCard idx card ] [ text "UG" ]
                                ]
                            ]
                    )
            )
        ]


addCardForm : Model -> Html Msg
addCardForm _ =
    div
        []
        [ text "カードの追加"
        , div
            [ css
                [ display grid
                , gridTemplateColumns <| List.repeat 10 "1fr"
                , gridColumnGap (px 10)
                , gridRowGap (px 10)
                ]
            ]
            (Card.possibleCards
                |> List.map
                    (\card ->
                        button [ onClick <| AddCard card, css [ borderStyle solid, borderWidth (px 1) ] ] [ text card.name ]
                    )
            )
        ]


removeCardForm : Model -> Html Msg
removeCardForm m =
    div []
        [ text <| "ステップ数: " ++ String.fromInt (History.length m.history)
        , div [] [ button [ onClick <| RevertChange ] [ text "戻す" ] ]
        ]


calcResult : State -> Html Msg
calcResult { cards, manaPerTurn, strength } =
    let
        damage =
            cards |> List.map (\card -> (toFloat card.attack + strength) * toFloat card.attackTimes) |> List.sum

        block =
            cards |> List.map .block |> List.sum |> toFloat

        cardCount =
            cards |> List.length

        drawSum =
            cards |> List.map .draw |> List.sum

        loopTurn =
            toFloat (cardCount - drawSum) / toFloat 5

        perLoop n =
            n / loopTurn

        perLoopMana valPerLoop =
            min valPerLoop (valPerLoop * ((manaPerTurn * loopTurn) / toFloat manaConsumeSum))

        dmgPerLoop =
            perLoop damage

        vulTurn =
            cards |> List.map .vulnerable |> List.sum |> toFloat |> max loopTurn

        dmgPerLoopVul =
            dmgPerLoop + (vulTurn / loopTurn) * dmgPerLoop * 0.5

        dmgPerLoopVulMana =
            perLoopMana dmgPerLoopVul

        manaConsumeSum =
            cards |> List.map .mana |> List.sum

        dmgPerLoopMana =
            perLoopMana dmgPerLoop

        blockPerLoop =
            perLoop block

        blockPerLoopMana =
            perLoopMana blockPerLoop
    in
    div [ css [ display grid, gridTemplateColumns [ "auto", "auto", "auto" ] ] ] <|
        List.concat
            [ floatField UpdateMana "マナ/ターン" manaPerTurn
            , floatField UpdateStrength "筋力(攻撃回数を考慮します)" strength
            , floatRow "総ダメージ" damage
            , floatRow "総ブロック" block
            , intRow "枚数" cardCount
            , intRow "総マナ消費" manaConsumeSum
            , intRow "総ドロー" drawSum
            , floatRow "一周ターン数" loopTurn
            , floatRowWithMana "ダメージ/ターン数" dmgPerLoop dmgPerLoopMana
            , floatRowWithMana "弱体考慮: ダメージ/ターン数 *1" dmgPerLoopVul dmgPerLoopVulMana
            , floatRowWithMana "ブロック/ターン数" blockPerLoop blockPerLoopMana
            ]


floatField : (Maybe Float -> Msg) -> String -> Float -> List (Html Msg)
floatField msg label val =
    [ div [] [ text label ]
    , input [ type_ "number", value <| String.fromFloat val, onInput (msg << String.toFloat) ] []
    , div [] []
    ]


intRow : String -> Int -> List (Html msg)
intRow s n =
    row String.fromInt s n


floatRow : String -> Float -> List (Html msg)
floatRow =
    row String.fromFloat


floatRowWithMana : String -> Float -> Float -> List (Html msg)
floatRowWithMana label val valMana =
    [ div [] [ text label ]
    , div [ css [ minWidth (px 170) ] ] [ text <| String.fromFloat val ]
    , div [] [ text <| "マナ考慮: " ++ String.fromFloat valMana ]
    ]


row : (num -> String) -> String -> num -> List (Html msg)
row formatter label val =
    [ div [] [ text label ]
    , div [] [ text <| formatter val ]
    , div [] []
    ]


main : Program () Model Msg
main =
    Browser.document
        { init = \_ -> noCmd initialModel
        , view = \m -> { title = "17式インスパイアデッキパワー計算機", body = List.map Html.Styled.toUnstyled <| view m }
        , subscriptions = \_ -> Sub.none
        , update = update
        }
