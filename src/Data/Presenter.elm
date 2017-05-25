module Data.Presenter exposing (..)

import Json.Decode as Decode exposing (Decoder, field, string, maybe)


type alias Presenter =
    { name : String
    , biograpy : String
    , twitterHandle : Maybe String
    , thumbnail : Maybe String
    }


decoder : Decoder Presenter
decoder =
    Decode.map4 Presenter
        (field "name" string)
        (field "biography" string)
        (maybe (field "twitterHandle" string))
        (maybe (field "thumbnail" string))
