port module DeviceOrientation exposing (..)
import Json.Encode exposing (Value)

port deviceOrientation : (Value -> msg) -> Sub msg
