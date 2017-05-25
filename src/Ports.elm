port module Ports exposing (..)


port saveFavourites : List String -> Cmd msg


port clearFavourites : String -> Cmd msg
