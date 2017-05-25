module Views.Event exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Data.Event
import Views.Tag
import Views.Presenter


type Msg
    = ToggleFavouriteEvent String


view : Data.Event.Event -> Html Msg
view event =
    let
        favouriteIconClass =
            case event.favourite of
                True ->
                    "favourite-event favourite-event--selected"

                False ->
                    "favourite-event"
    in
        div [ class "list-group-item" ]
            [ div [ class favouriteIconClass, onClick (ToggleFavouriteEvent event.id) ] [ span [ class "glyphicon glyphicon-star" ] [] ]
            , h4 [ class "list-group-item-heading" ] [ text event.title ]
            , div [ class "list-group-item-text small" ]
                [ p [] [ span [ class "glyphicon glyphicon-calendar" ] [], text (" " ++ event.time) ]
                , p [] [ span [ class "glyphicon glyphicon-map-marker" ] [], text (" " ++ event.location) ]
                , div [] (List.map Views.Tag.view event.tags)
                , br [] []
                , div [] (List.map Views.Presenter.view event.presenters)
                ]
            ]


list events =
    div [ class "list-group" ] (List.map view events)
