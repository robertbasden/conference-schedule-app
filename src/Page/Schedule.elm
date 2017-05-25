module Page.Schedule exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, classList)
import Html.Events exposing (onClick)
import Data.Event
import Data.Day
import Views.DaySelect
import Views.Event


type alias Model =
    { daySelect : Views.DaySelect.Model
    , onlyShowFavourites : Bool
    }


type Msg
    = EventViewMsg Views.Event.Msg
    | DaySelectMsg Views.DaySelect.Msg
    | ToggleOnlyShowFavourites


init =
    Model Views.DaySelect.init False


update message model =
    case message of
        DaySelectMsg msg ->
            { model | daySelect = Views.DaySelect.update msg model.daySelect }

        ToggleOnlyShowFavourites ->
            { model | onlyShowFavourites = model.onlyShowFavourites == False }

        _ ->
            model


view events model =
    let
        eventsToDisplay =
            events
                |> List.filter (\event -> event.day == model.daySelect.selectedDay)
                |> List.filter (\event -> model.onlyShowFavourites == False || event.favourite == True)
    in
        div []
            [ a [ classList [ ( "onlyShowFavouritesFilter", True ), ( "onlyShowFavouritesOn", model.onlyShowFavourites ) ], onClick ToggleOnlyShowFavourites ] [ span [ class "glyphicon glyphicon-star onlyShowFavouritesStar" ] [] ]
            , (Html.map DaySelectMsg (Views.DaySelect.view model.daySelect))
            , (Html.map EventViewMsg (Views.Event.list eventsToDisplay))
            ]
