module Main exposing (..)

import Browser
import Card exposing (Card)
import Card.Ironclad as Card
import Css exposing (..)
import History exposing (History)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (..)
import List.Extra
import RecordSetter exposing (..)
import StylesExtra exposing (gapByMargin, gapByMarginLeft)
import Utils exposing (noCmd)


type alias Model =
    { cards : History (List Card) }


initialModel : Model
initialModel =
    { cards = History.init <| initialCards }


initialCards : List Card
initialCards =
    List.repeat 5 Card.strike ++ List.repeat 4 Card.guard ++ [ Card.bash ]


type Msg
    = AddCard Card
    | RemoveCard Int
    | UpgradeCard Int Card
    | RevertCard


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

        RevertCard ->
            model
                |> s_cards (model.cards |> History.pop)
                |> noCmd


pushCardsHistory : (List Card -> List Card) -> Model -> Model
pushCardsHistory f m =
    let
        newCards =
            m.cards |> History.newest initialCards |> f
    in
    m
        |> s_cards (History.push newCards m.cards)


view : Model -> List (Html Msg)
view m =
    [ div [ css [ gapByMargin 30 ] ]
        [ currentCardList m
        , addCardForm m
        , removeCardForm m
        , calcResut m
        ]
    ]


currentCardList : Model -> Html Msg
currentCardList m =
    div []
        [ text "カード一覧"
        , div [ css [ displayFlex, gapByMarginLeft 20 ] ]
            (m.cards
                |> History.newest initialCards
                |> List.indexedMap
                    (\idx card ->
                        div []
                            [ Card.view card
                            , button [ onClick <| RemoveCard idx ] [ text "除去" ]
                            , button [ onClick <| UpgradeCard idx card ] [ text "UG" ]
                            ]
                    )
            )
        ]


addCardForm : Model -> Html Msg
addCardForm _ =
    div []
        [ text "カードの追加"
        , div []
            (possibleCards
                |> List.map
                    (\card ->
                        button [ onClick <| AddCard card, css [ borderStyle solid, borderWidth (px 1) ] ] [ text card.name ]
                    )
            )
        ]


removeCardForm : Model -> Html Msg
removeCardForm m =
    div []
        [ text <| "ステップ数: " ++ String.fromInt (History.length m.cards)
        , div [] [ button [ onClick <| RevertCard ] [ text "戻す" ] ]
        ]


possibleCards : List Card
possibleCards =
    [ Card.anger ]


calcResut : Model -> Html Msg
calcResut m =
    let
        currentCards =
            m.cards |> History.newest initialCards

        damage =
            currentCards |> List.map .attack |> List.sum

        block =
            currentCards |> List.map .guard |> List.sum

        cardCount =
            currentCards |> List.length

        loopTurn =
            -- TODO draw
            toFloat cardCount / toFloat 5

        perLoop n =
            toFloat n / loopTurn

        perLoopMana vPerLoop =
            -- TODO manaperturn
            min vPerLoop (vPerLoop * (3 * loopTurn / toFloat manaSum))

        dmgPerLoop =
            perLoop damage

        manaSum =
            currentCards |> List.map .mana |> List.sum

        dmgPerLoopMana =
            perLoopMana dmgPerLoop

        blockPerLoop =
            perLoop block

        blockPerLoopMana =
            perLoopMana blockPerLoop
    in
    div []
        [ intRow "総ダメージ" damage
        , intRow "総ブロック" block
        , intRow "枚数" cardCount
        , intRow "総マナ" manaSum
        , floatRow "一周ターン数" loopTurn
        , floatRowWithMana "ダメージ/ターン数" dmgPerLoop dmgPerLoopMana
        , floatRowWithMana "ブロック/ターン数" blockPerLoop blockPerLoopMana
        ]


intRow : String -> Int -> Html msg
intRow =
    row String.fromInt


floatRow : String -> Float -> Html msg
floatRow =
    row String.fromFloat


floatRowWithMana : String -> Float -> Float -> Html msg
floatRowWithMana label val valMana =
    div [ css [ displayFlex, gapByMarginLeft 10 ] ]
        [ div [] [ text label ]
        , div [ css [ minWidth (px 170) ] ] [ text <| String.fromFloat val ]
        , div [] [ text <| "マナ考慮: " ++ String.fromFloat valMana ]
        ]


row : (num -> String) -> String -> num -> Html msg
row formatter label val =
    div [ css [ displayFlex, gapByMarginLeft 10 ] ]
        [ div [] [ text label ]
        , div [] [ text <| formatter val ]
        ]


main : Program () Model Msg
main =
    Browser.document
        { init = \_ -> noCmd initialModel
        , view = \m -> { title = "17式インスパイアデッキパワー計算機", body = List.map Html.Styled.toUnstyled <| view m }
        , subscriptions = \_ -> Sub.none
        , update = update
        }
