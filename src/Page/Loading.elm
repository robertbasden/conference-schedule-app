module Page.Loading exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)


view =
    div []
        [ div [ class "loader" ] []
        ]
