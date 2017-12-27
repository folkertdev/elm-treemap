# Treemaps in Elm 

Treemaps are a method of visualizing data to communicate the relative size of some value.

Here is an example displaying the GDP for some european countries: 

<img style="max-width: 100%;" src="https://rawgit.com/folkertdev/elm-treemap/master/docs/smallEuropeanGDP.svg" />

An here's the code:

```elm
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

```

## customizing your plots 

This package is quite opinionated when it comes to styling: you get a box and a label. 
The box has a color and a border (both can depend on the relative area of the box), and the label
has a color and a size (again, both can depend on the relative area of the surrounding box). 

If you need more than that, use `Treemap.generate` to give you a list of boxes, and go from there. 
The package source contains a bunch of tricks for positioning the box and label, and for 
multi-line text in svg. These can be used with `Treemap.renderLabel` and `Treemap.renderBox`, or copied
if you need something really custom.

That said, if you think some other property should be part of the options, or 
some other part of this package isn't flexible enough, open an issue or 
send me a message on the elm slack (@folkertdev). 
