module Data.Event exposing (..)

import Json.Decode as Decode exposing (Decoder, string, int, list, succeed)
import Json.Decode.Pipeline exposing (decode, required, hardcoded, resolve)
import Data.Presenter
import Data.Day


type alias Event =
    { id : String
    , title : String
    , description : String
    , tags : List String
    , location : String
    , time : String
    , presenters : List Data.Presenter.Presenter
    , day : Data.Day.Day
    , favourite : Bool
    }


clearFavourites : List Event -> List Event
clearFavourites events =
    events
        |> List.map (\event -> { event | favourite = False })


toggleFavourite : String -> List Event -> List Event
toggleFavourite id events =
    events
        |> List.map
            (\event ->
                if event.id == id then
                    { event | favourite = event.favourite == False }
                else
                    event
            )


setFavourites : List String -> List Event -> List Event
setFavourites ids events =
    events
        |> List.map
            (\event ->
                if (List.member event.id ids) then
                    { event | favourite = True }
                else
                    event
            )


decoder : Decoder Event
decoder =
    let
        process id title description tags location time presenters day favourite =
            succeed (Event id title description tags location time presenters (Data.Day.fromString day) favourite)
    in
        decode process
            |> required "id" string
            |> required "title" string
            |> required "description" string
            |> required "tags" (list string)
            |> required "location" string
            |> required "time" string
            |> required "presenters" (list Data.Presenter.decoder)
            |> required "day" string
            |> hardcoded False
            |> resolve
