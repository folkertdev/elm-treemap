module TreeMap exposing (..)


type TreeMap
    = TreeMap


type alias Offset =
    { x : Float, y : Float }


type alias Container =
    { offset : Offset, width : Float, height : Float }


type alias Coordinate =
    ( Float, Float, Float, Float )


shortestEdge : Container -> Float
shortestEdge { width, height } =
    min width height


{-| for a row of boxes which we've placed return an array of their cartesian coordinates
-}
getCoordinates : List Float -> Container -> List Coordinate
getCoordinates row ({ width, height } as container) =
    let
        areaWidth =
            List.sum row / height

        areaHeight =
            List.sum row / width

        initialSubxoffset =
            container.offset.x

        initialSubyoffset =
            container.offset.y
    in
        if width >= height then
            let
                ratios =
                    row
                        |> List.map (\datum -> datum / areaWidth)
                        |> List.scanl (+) initialSubyoffset

                determineBox current subyoffset =
                    ( initialSubxoffset
                    , subyoffset
                    , initialSubxoffset + areaWidth
                    , subyoffset + current / areaWidth
                    )
            in
                List.map2 determineBox row ratios
        else
            let
                ratios =
                    row
                        |> List.map (\datum -> datum / areaHeight)
                        |> List.scanl (+) initialSubxoffset

                determineBox current subxoffset =
                    ( subxoffset
                    , initialSubyoffset
                    , subxoffset + current / areaHeight
                    , initialSubyoffset + areaHeight
                    )
            in
                List.map2 determineBox row ratios


{-| Once we've placed some boxes into an row we then need to identify the remaining area,
               this function takes the area of the boxes we've placed and calculates the location and
               dimensions of the remaining space and returns a container box defined by the remaining area
-}
cutArea : Float -> Container -> Container
cutArea area ({ width, height } as container) =
    if width >= height then
        let
            areaWidth =
                area / height

            newWidth =
                width - areaWidth
        in
            { offset =
                { x = container.offset.x + areaWidth
                , y = container.offset.y
                }
            , width = newWidth
            , height = height
            }
    else
        let
            areaHeight =
                area / width

            newHeight =
                height - areaHeight
        in
            { offset =
                { x = container.offset.x
                , y = container.offset.y + areaHeight
                }
            , width = width
            , height = newHeight
            }



{- | the Bruls algorithm assumes we're passing in areas that nicely fit into our
   container box, this method takes our raw data and normalizes the data values into
   area values so that this assumption is valid.
-}


normalize : Float -> List Float -> List Float
normalize area data =
    let
        multiplier =
            area / List.sum data
    in
        List.map (\datum -> datum * multiplier) data


{-| calculates the maximum width to height ratio of the
   boxes in this row
-}
calculateRatio : List Float -> Float -> Float
calculateRatio row length =
    case row of
        [] ->
            0

        r :: rs ->
            let
                folder current ( a, b, c ) =
                    ( min current a
                    , max current b
                    , (+) current c
                    )

                ( minimal, maximal, total ) =
                    List.foldl folder ( r, r, r ) rs
            in
                max
                    (length ^ 2 * maximal / (total ^ 2))
                    ((total ^ 2) / ((length ^ 2) * minimal))


{-| implements the worse calculation and comparision as given in Bruls
                           (note the error in the original paper; fixed here)
-}
improvesRatio : List Float -> Float -> Float -> Bool
improvesRatio currentRow nextnode length =
    if List.length currentRow == 0 then
        True
    else
        let
            newRow =
                currentRow ++ [ nextnode ]

            currentratio =
                calculateRatio currentRow length

            newratio =
                calculateRatio newRow length
        in
            -- the pseudocode in the Bruls paper has the direction of the comparison
            -- wrong, this is the correct one.
            currentratio >= newratio


{-| as per the Bruls paper
           plus coordinates stack and containers so we get
           usable data out of it
-}
squarify : List Float -> List Float -> Container -> List (List Coordinate) -> List (List Coordinate)
squarify data currentRow container stack =
    case data of
        [] ->
            getCoordinates currentRow container :: stack

        d :: ds ->
            let
                length =
                    shortestEdge container
            in
                if improvesRatio currentRow d length then
                    squarify ds (currentRow ++ [ d ]) container stack
                else
                    let
                        newContainer =
                            cutArea (List.sum currentRow) container

                        newStack =
                            getCoordinates currentRow container :: stack
                    in
                        squarify data [] newContainer newStack


treemapSingledimensional : Container -> List Float -> List Coordinate
treemapSingledimensional container data =
    squarify (normalize (container.width * container.height) data) [] container []
        |> List.foldl (++) []
