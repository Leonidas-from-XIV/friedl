module Main exposing (main)

{-|

@docs main

-}

import Html exposing (text, div, img, Attribute, programWithFlags)
import Html.Attributes exposing (src, style, class)
import Html.Events exposing (on)
import Json.Decode as Json exposing (field, Decoder)


type alias Model =
    { current : Int
    , images : List String
    , segmentWidth : Maybe Float
    }


{-| Starts the program
-}
main : Program (List String) Model Msg
main =
    programWithFlags
        { view = view
        , update = update
        , subscriptions = subscriptions
        , init = init
        }


type Msg
    = Move Int Int
    | Load Int


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


init : List String -> ( Model, Cmd Msg )
init images =
    ( { current = 0, images = images, segmentWidth = Nothing }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
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
                    ( { model | segmentWidth = Just segmentWidth }, Cmd.none )

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
                    ( { model | current = currentSegment }, Cmd.none )


moveDecoder : Decoder Msg
moveDecoder =
    Json.map2 Move (field "clientX" Json.int) (Json.at [ "target", "offsetWidth" ] Json.int)


onMouseMove : Attribute Msg
onMouseMove =
    on "mousemove" moveDecoder


loadDecoder : Decoder Msg
loadDecoder =
    Json.map Load (Json.at [ "target", "naturalWidth" ] Json.int)


onLoad : Attribute Msg
onLoad =
    on "load" loadDecoder


list_get : List a -> Int -> Maybe a
list_get xs n =
    List.drop n xs |> List.head


touchMoveDecoder =
    Json.map2 (,)
        (Json.at [ "changedTouches", "0" ] (Json.map truncate (field "clientX" Json.float)))
        (Json.at [ "target", "offsetWidth" ] Json.int)
        |> Json.map (\( clientX, width ) -> Move (min (max 0 clientX) width) width)


onTouchMove =
    on "touchmove" touchMoveDecoder


view : Model -> Html.Html Msg
view model =
    div
        [ onMouseMove
        , onTouchMove
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
                    [ style [ ( "display", "none" ) ] ]
                    (List.map (\url -> img [ src url ] []) model.images)
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
