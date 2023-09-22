module StylesExtra exposing (..)

import Css exposing (..)
import Css.Global exposing (children, everything)


gapByMargin : Float -> Style
gapByMargin n =
    children [ everything [ nthChild "n+2" [ marginTop (px n) ] ] ]


gapByMarginLeft : Float -> Style
gapByMarginLeft n =
    children [ everything [ nthChild "n+2" [ marginLeft (px n) ] ] ]
