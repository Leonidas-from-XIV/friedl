module Main exposing (..)

import Html exposing (text, div, img, Attribute)
import Html.Attributes exposing (src, style, class)
import Html.App as App
import Json.Decode as Json exposing ((:=), Decoder)


images =
    [ "https://xivilization.net/~marek/wiggle/tree0.jpg"
    , "https://xivilization.net/~marek/wiggle/tree1.jpg"
    , "https://xivilization.net/~marek/wiggle/tree2.jpg"
    , "https://xivilization.net/~marek/wiggle/tree3.jpg"
    , "https://xivilization.net/~marek/wiggle/tree4.jpg"
    , "https://xivilization.net/~marek/wiggle/tree5.jpg"
    , "https://xivilization.net/~marek/wiggle/tree6.jpg"
    , "https://xivilization.net/~marek/wiggle/tree7.jpg"
    , "https://xivilization.net/~marek/wiggle/tree8.jpg"
    , "https://xivilization.net/~marek/wiggle/tree9.jpg"
    ]


type alias Model =
    { current : Int
    , images : List (String)
    , segmentWidth : Maybe Float
    }


main =
    App.beginnerProgram
        { view = view
        , update = update
        , model =
            { current = 0
            , images = images
            , segmentWidth = Nothing
            }
        }


type Msg
    = Move Int Int
    | Load Int


update : Msg -> Model -> Model
update msg model =
    let
        count =
            model.images |> List.length
    in
        case msg of
            Load width ->
                let
                    segmentWidth =
                        (toFloat width) / (toFloat count)
                in
                    { model | segmentWidth = Just segmentWidth }

            Move cursor width ->
                let
                    segmentWidth =
                        width // count

                    part =
                        cursor // segmentWidth

                    currentSegment =
                        if part < count then
                            part
                        else
                            count - 1
                in
                    { model | current = currentSegment }


moveDecoder : Decoder Msg
moveDecoder =
    Json.object2 Move ("clientX" := Json.int) (Json.at [ "target", "offsetWidth" ] Json.int)


onMouseMove : Attribute Msg
onMouseMove =
    Html.Events.on "mousemove" moveDecoder


loadDecoder : Decoder Msg
loadDecoder =
    Json.map Load (Json.at [ "target", "naturalWidth" ] Json.int)


onLoad : Attribute Msg
onLoad =
    Html.Events.on "load" loadDecoder


list_get : List a -> Int -> Maybe a
list_get xs n =
    List.drop n xs |> List.head


view : Model -> Html.Html Msg
view model =
    div
        [ onMouseMove
        , class "image-wrapper"
        , style
            [ ( "display", "inline-block" )
            , ( "border", "1px solid black" )
            ]
        ]
        (case list_get model.images model.current of
            Nothing ->
                []

            Just url ->
                [ img
                    [ src url
                    , onLoad
                    ]
                    []
                , div
                    []
                    (case model.segmentWidth of
                        Nothing ->
                            []

                        Just segmentWidth ->
                            [ div
                                [ style
                                    [ ( "border-right", toString segmentWidth ++ "px solid black" )
                                    , ( "width", toString (segmentWidth * (toFloat model.current)) ++ "px" )
                                    , ( "height", "2px" )
                                    ]
                                ]
                                []
                            ]
                    )
                ]
        )
