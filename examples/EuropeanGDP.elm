module Main exposing (..)

import Treemap
import Svg exposing (Svg)
import Svg.Attributes
import Color


main : Svg msg
main =
    let
        defaultOptions =
            Treemap.defaultOptions

        color1 =
            Color.rgb 70 130 180

        color2 =
            Color.rgb 146 249 159

        options =
            { defaultOptions
                | boxColor = Treemap.colorInterpolate color1 color2
                , fontColor = \_ -> Color.white
                , fontSize = Treemap.floatInterpolate { minimum = 8, maximum = 20 }
                , border = \_ -> { width = 1, color = Color.white }
                , breakLabel = Treemap.OnWhiteSpace
            }
    in
        Svg.svg [ Svg.Attributes.width "700", Svg.Attributes.height "500" ] <|
            Treemap.drawWithOptions options { width = 700, height = 500 } shortData


{-| handpicked for more variation in size
-}
shortData : List ( String, Float )
shortData =
    [ ( "Luxembourg", 101.936 )
    , ( "Norway", 69.296 )
    , ( "Ireland", 69.375 )
    , ( "Iceland", 48.07 )
    , ( "Netherlands", 50.846 )
    , ( "Georgia", 10.1 )
    , ( "Slovak Republic", 31.182 )
    , ( "Latvia", 25.74 )
    , ( "Hungary", 26.275 )
    , ( "Armenia", 8.881 )
    , ( "Ukraine", 8.23 )
    ]


{-| European GDP data (PPP, 2016)

source: http://statisticstimes.com/economy/european-countries-by-gdp-per-capita.php
-}
data : List ( String, Float )
data =
    [ ( "Luxembourg", 101.936 )
    , ( "Switzerland", 59.376 )
    , ( "Norway", 69.296 )
    , ( "Ireland", 69.375 )
    , ( "Iceland", 48.07 )
    , ( "Denmark", 46.603 )
    , ( "Sweden", 49.678 )
    , ( "San Marino", 64.444 )
    , ( "Netherlands", 50.846 )
    , ( "Austria", 47.856 )
    , ( "Finland", 41.813 )
    , ( "Germany", 48.19 )
    , ( "Belgium", 44.881 )
    , ( "United Kingdom", 42.514 )
    , ( "France", 42.384 )
    , ( "Italy", 36.313 )
    , ( "Spain", 36.451 )
    , ( "Malta", 37.891 )
    , ( "Cyprus", 34.387 )
    , ( "Slovenia", 32.028 )
    , ( "Portugal", 28.515 )
    , ( "Czech Republic", 33.223 )
    , ( "Greece", 26.809 )
    , ( "Estonia", 29.502 )
    , ( "Slovak Republic", 31.182 )
    , ( "Lithuania", 29.882 )
    , ( "Latvia", 25.74 )
    , ( "Poland", 26.499 )
    , ( "Hungary", 26.275 )
    , ( "Croatia", 22.415 )
    , ( "Romania", 22.319 )
    , ( "Turkey", 21.147 )
    , ( "Russia", 25.965 )
    , ( "Bulgaria", 20.116 )
    , ( "Montenegro", 17.035 )
    , ( "Serbia", 14.226 )
    , ( "Belarus", 17.715 )
    , ( "FYR Macedonia", 14.53 )
    , ( "Bosnia and Herzegovina", 11.034 )
    , ( "Albania", 11.861 )
    , ( "Georgia", 10.1 )
    , ( "Azerbaijan", 17.688 )
    , ( "Armenia", 8.881 )
    , ( "Ukraine", 8.23 )
    , ( "Moldova", 5.218 )
    ]
