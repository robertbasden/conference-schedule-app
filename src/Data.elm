module Data exposing (..)

import Json.Decode as Decode exposing (Decoder, field, list)
import Http
import Data.Event


type alias Data =
    { events : List Data.Event.Event
    }


getData msg =
    let
        request =
            Http.get "data.json" decoder
    in
        Http.send msg request


decoder =
    Decode.map Data
        (field "events" (list Data.Event.decoder))
