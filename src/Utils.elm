module Utils exposing (..)

import Css exposing (..)
import Html.Styled exposing (Html, text)


noHtml : Html msg
noHtml =
    text ""


noCmd : model -> ( model, Cmd msg )
noCmd m =
    ( m, Cmd.none )


putIn : (a -> b -> c) -> b -> a -> c
putIn setter m field =
    setter field m



-----------------
-- Grid Layout
-----------------


{-| 本来は `grid = { value = "grid", display = Compatible }` となるべきだが、Css.Structure.Compatible が公開されていないため、既存の `block` での指定を書き換えて使用する
-}
grid : Display {}
grid =
    { block | value = "grid" }


gridTemplateRows : List String -> Style
gridTemplateRows units =
    property "grid-template-rows" <| String.join " " units


gridTemplateColumns : List String -> Style
gridTemplateColumns units =
    property "grid-template-columns" <| String.join " " units


{-| Might consider accepting `String` since some units are not covered by `Length` yet
-}
gridAutoRows : Length compatible units -> Style
gridAutoRows =
    prop1 "grid-auto-rows"


{-| Might consider accepting `String` since some units are not covered by `Length` yet
-}
gridAutoColumns : Length compatible units -> Style
gridAutoColumns =
    prop1 "grid-auto-columns"


gridRow : String -> Style
gridRow =
    property "grid-row"


gridColumn : String -> Style
gridColumn =
    property "grid-column"


gridRowGap : Length compatible units -> Style
gridRowGap =
    prop1 "grid-row-gap"


gridColumnGap : Length compatible units -> Style
gridColumnGap =
    prop1 "grid-column-gap"


gridGap : Length compatible units -> Style
gridGap =
    prop1 "grid-gap"


{-| Sets `justify-items`.

Convenient for placing items center along the appropriate axis in grid layout. Missing in elm-css.

Supported in all major browsers for flex layout, but not for grid layout in IE.

<https://developer.mozilla.org/en-US/docs/Web/CSS/justify-items>

-}
justifyItems : String -> Style
justifyItems =
    property "justify-items"


{-| Sets `justify-self`.

Convenient for placing an element center along the appropriate axis in grid layout. Missing in elm-css.

Supported in all major browsers except IE.

<https://developer.mozilla.org/en-US/docs/Web/CSS/justify-self>

-}
justifySelf : String -> Style
justifySelf =
    property "justify-self"



-----------------
-- Private functions ported from elm-css
-----------------


prop1 : String -> Value a -> Style
prop1 key arg =
    property key arg.value
