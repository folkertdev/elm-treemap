module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string, float)
import Test exposing (..)
import Internal as TreeMap


rawtreemap =
    let
        container =
            { offset = { x = 0, y = 0 }, width = 100, height = 100 }

        template name data expected =
            test name <|
                \_ ->
                    TreeMap.squarify (TreeMap.normalize (container.width * container.height) data) [] container []
                        |> List.reverse
                        |> Expect.equal expected
    in
        describe "rawtreemap"
            [ template "1"
                [ 1, 2, 3 ]
                [ [ ( 0, 0, 50, 33.333333333333336 )
                  , ( 0, 33.333333333333336, 50, 100 )
                  ]
                , [ ( 50, 0, 100, 100 ) ]
                ]
            ]


getCoordinates : Test
getCoordinates =
    let
        template name input expected =
            test name <|
                \_ ->
                    TreeMap.getCoordinates input container
                        |> Expect.equal expected

        container =
            { offset = { x = 5, y = 5 }, width = 100, height = 100 }
    in
        describe "getCoordinates"
            [ template "empty list" [] []
            , template "[1]" [ 1 ] [ ( 5, 5, 5.01, 105 ) ]
            , template "[5000]" [ 5000 ] [ ( 5, 5, 55, 105 ) ]
            , test "error case" <|
                \_ ->
                    let
                        container =
                            { offset = { x = 50, y = 0 }, width = 50, height = 100 }
                    in
                        TreeMap.getCoordinates [ 5000 ] container
                            |> Expect.equal [ ( 50, 0, 100, 100 ) ]
            ]


squarify : Test
squarify =
    let
        template name input input2 input3 expected =
            test name <|
                \_ ->
                    TreeMap.squarify input input2 container input3
                        |> Expect.equal expected

        container =
            { offset = { x = 5, y = 5 }, width = 100, height = 100 }
    in
        describe "squarify"
            [ template "1" [ 1 ] [] [] [ [ ( 5, 5, 5.01, 105 ) ] ]
            , template "2"
                [ 1, 2 ]
                []
                []
                [ [ ( 5, 5, 5.03, 38.333333333333336 )
                  , ( 5, 38.333333333333336, 5.03, 105 )
                  ]
                ]
            , template "3"
                [ 1, 2 ]
                []
                []
                [ [ ( 5, 5, 5.03, 38.333333333333336 ), ( 5, 38.333333333333336, 5.03, 105 ) ] ]
            , template "4"
                [ 3 ]
                [ 1, 2 ]
                []
                [ [ ( 5, 5, 5.06, 21.666666666666668 )
                  , ( 5, 21.666666666666668, 5.06, 55 )
                  , ( 5, 55, 5.06, 105 )
                  ]
                ]
            , template "5"
                [ 2, 3 ]
                [ 1 ]
                []
                [ [ ( 5, 5, 5.06, 21.666666666666668 )
                  , ( 5, 21.666666666666668, 5.06, 55 )
                  , ( 5, 55, 5.06, 105 )
                  ]
                ]
            ]


cutArea : Test
cutArea =
    let
        template name input expected =
            test name <|
                \_ ->
                    TreeMap.cutArea input container
                        |> Expect.equal expected

        container =
            { offset = { x = 5, y = 5 }, width = 100, height = 100 }
    in
        describe "cutArea"
            [ template "area 0" 0 container
            , template "area 20" 20 { offset = { x = 5.2, y = 5 }, width = 99.8, height = 100 }
            , template "area 5000" 5000 { offset = { x = 55, y = 5 }, width = 50, height = 100 }
            ]


calculateRatioEmptyList =
    fuzz float "calculateRatio returns 0 for an empty row" <|
        \length ->
            TreeMap.calculateRatio [] length
                |> Expect.equal 0


calculateRatio =
    test "calculateRatio behaves like js" <|
        \length ->
            TreeMap.calculateRatio [ 1, 2, 3, 4, 5 ] 42
                |> Expect.equal 39.2


normalize =
    let
        template name data area expected =
            test name <|
                \_ ->
                    TreeMap.normalize area data
                        |> Expect.equal expected
    in
        describe "normalize"
            [ template "1" [ 1, 2, 3 ] (100 * 100) [ 1666.6666666666667, 3333.3333333333335, 5000 ]
            , template "2" [ 1, 2 ] (100 * 100) [ 3333.3333333333335, 6666.666666666667 ]
            ]


improvesRatio =
    let
        template name row next length expected =
            test name <|
                \_ ->
                    TreeMap.improvesRatio row next length
                        |> Expect.equal expected
    in
        describe "improvesRatio"
            [ test "behaves like js true" <|
                \_ ->
                    TreeMap.improvesRatio [ 1, 2, 3, 4, 5 ] 6 42
                        |> Expect.equal True
            , test "behaves like js false" <|
                \_ ->
                    TreeMap.improvesRatio [ 1, 2, 3, 4, 5 ] 2000 42
                        |> Expect.equal False
            , template "1" [ 1, 10 ] 0.01 10 False
            , template "2" [ 1, 10 ] 0.01 100 True
            , template "3" [ 1, 100 ] 0.01 100 False
            , template "4" [ 1666.6666666666667, 3333.3333333333335 ] 5000 100 False
            ]


treemapSingledimensionalSimple =
    let
        template name input expected =
            test name <|
                \_ ->
                    let
                        container =
                            { offset = { x = 0, y = 0 }, width = 100, height = 100 }
                    in
                        TreeMap.treemapSingledimensional container input
                            |> Expect.equal
                                expected
    in
        describe "treemapSingledimensional simple"
            [ template "split in 1:1" [ 2, 2 ] [ ( 0, 0, 100, 50 ), ( 0, 50, 100, 100 ) ]
            , template "split in 1:2" [ 1, 2 ] [ ( 0, 0, 100, 33.333333333333336 ), ( 0, 33.333333333333336, 100, 100 ) ]
            , template "split in 1:2:3" [ 1, 2, 3 ] [ ( 0, 0, 50, 33.333333333333336 ), ( 0, 33.333333333333336, 50, 100 ), ( 50, 0, 100, 100 ) ]
            ]


treemapSingledimensional =
    describe "treemapSingledimensional"
        [ test "behaves like js 1" <|
            \_ ->
                let
                    container =
                        { offset = { x = 0, y = 0 }, width = 100, height = 100 }
                in
                    TreeMap.treemapSingledimensional container [ 1, 2, 3, 4, 5 ]
                        |> Expect.equal
                            [ ( 0, 0, 40, 16.666666666666664 )
                            , ( 0, 16.666666666666664, 40, 49.99999999999999 )
                            , ( 0, 49.99999999999999, 40, 100 )
                            , ( 40, 0, 100, 44.44444444444444 )
                            , ( 40, 44.44444444444444, 100, 100 )
                            ]
        , test "behaves like js 2" <|
            \_ ->
                let
                    container =
                        { offset = { x = 5, y = 5 }, width = 100, height = 100 }
                in
                    TreeMap.treemapSingledimensional container [ 1, 2, 3, 4, 5 ]
                        |> Expect.equal
                            [ ( 5, 5, 45, 21.666666666666664 )
                            , ( 5, 21.666666666666664, 45, 54.99999999999999 )
                            , ( 5, 54.99999999999999, 45, 105 )
                            , ( 45, 5, 105, 49.44444444444444 )
                            , ( 45, 49.44444444444444, 105, 105 )
                            ]
        ]
