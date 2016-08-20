import Html exposing (text, div, img)
import Html.Attributes exposing (src, style, class)
import Html.Events exposing (onMouseOver)
import Html.App as App
import Json.Decode as Json exposing ((:=))

images = [ "https://xivilization.net/~marek/wiggle/tree0.jpg"
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

type alias Model = { current : Int,
                     images : List (String) }

main =
  App.beginnerProgram {
          view = view,
          update = update,
          model = { current = 0,
                    images = images }
  }

type Msg =
  Move Int Int

update : Msg -> Model -> Model
update msg model =
  case msg of
    Move cursor width ->
      let count = model.images |> List.length
          segmentWidth = width // count
          currentSegment = cursor // segmentWidth
      in
      Debug.log (toString currentSegment)
              { model | current = currentSegment }

moveDecoder : Json.Decoder Msg
moveDecoder = Json.object2 Move ("clientX" := Json.int) (Json.at ["target", "offsetWidth"] Json.int)

onMouseMove : Html.Attribute Msg
onMouseMove =
  Html.Events.on "mousemove" moveDecoder

view : Model -> Html.Html Msg
view model =
  div []
    [ div
       [ onMouseMove
       , class "image-wrapper"
       , style [("background-color", "#FF00FF")
               ,("display", "inline-block")]]
       [ img [ src "https://xivilization.net/~marek/wiggle/tree0.jpg" ] [] ]
    ]
