module Page.Settings exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)


type alias Model =
    {}


type Msg
    = ClearFavourites


init =
    Model


view =
    div []
        [ h4 [] [ text "Settings" ]
        , a [ class "btn btn-danger", href "#", onClick ClearFavourites ] [ text "Clear favourites" ]
        ]
