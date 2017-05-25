module Data.Day exposing (..)


type Day
    = Friday
    | Saturday
    | Sunday


fromString : String -> Day
fromString dayString =
    case dayString of
        "Friday" ->
            Friday

        "Saturday" ->
            Saturday

        "Sunday" ->
            Sunday

        _ ->
            Friday
