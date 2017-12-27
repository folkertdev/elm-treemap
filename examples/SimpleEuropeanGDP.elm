module Main exposing (..)

import Treemap
import Svg exposing (Svg)
import Svg.Attributes


main : Svg msg
main =
    let
        defaultOptions =
            Treemap.defaultOptions

        options =
            { defaultOptions
                | fontSize = Treemap.floatInterpolate { minimum = 8, maximum = 20 }
                , breakLabel = Treemap.OnWhiteSpace
            }
    in
        Svg.svg [ Svg.Attributes.width "600", Svg.Attributes.height "500" ] <|
            Treemap.drawWithOptions options { width = 600, height = 500 } (data)


data : List ( String, Float )
data =
    [ ( "Ireland", 69.375 )
    , ( "Iceland", 48.07 )
    , ( "Netherlands", 50.846 )
    , ( "Estonia", 29.502 )
    , ( "Latvia", 25.74 )
    , ( "Poland", 26.499 )
    , ( "Ukraine", 8.23 )
    , ( "Moldova", 5.218 )
    ]
