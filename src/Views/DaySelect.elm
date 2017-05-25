module Views.DaySelect exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)
import Data.Day


type alias Model =
    { selectedDay : Data.Day.Day
    }


type Msg
    = SelectDay Data.Day.Day


init =
    Model Data.Day.Friday


update message model =
    case message of
        SelectDay day ->
            { model | selectedDay = day }


view model =
    let
        isActive day =
            day == model.selectedDay
    in
        ul [ class "nav nav-pills" ]
            [ li [ classList [ ( "active", isActive Data.Day.Friday ) ], onClick (SelectDay Data.Day.Friday) ]
                [ a [ href "#" ] [ text "Friday" ] ]
            , li
                [ classList [ ( "active", isActive Data.Day.Saturday ) ], onClick (SelectDay Data.Day.Saturday) ]
                [ a [ href "#" ] [ text "Saturday" ] ]
            , li
                [ classList [ ( "active", isActive Data.Day.Sunday ) ], onClick (SelectDay Data.Day.Sunday) ]
                [ a [ href "#" ] [ text "Sunday" ] ]
            ]
