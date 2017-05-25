module Views.Tag exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)


view : String -> Html msg
view tag =
    span [ class "label label-default" ] [ text tag ]
