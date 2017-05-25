module Main exposing (..)

import Html
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Ports
import Data
import Data.Day
import Data.Event
import Data.Presenter
import Page.Schedule
import Page.Loading
import Page.Settings
import Views.Tag
import Views.DaySelect
import Views.Presenter
import Views.Event


type AppState
    = Loading
    | Loaded
    | Error


type Page
    = Schedule
    | Settings


type DataLoadingState
    = NotRequested
    | WaitingForData
    | DataFetched Data.Data
    | DataFetchError


type Msg
    = SchedulePageMsg Page.Schedule.Msg
    | SettingsPageMsg Page.Settings.Msg
    | DataLoaded (Result Http.Error Data.Data)
    | ToggleFavourite String
    | ClearFavourites
    | SwitchPage Page
    | ToggleMobileNav


type alias Model =
    { data : DataLoadingState
    , savedFavouritesList : List String
    , schedulePage : Page.Schedule.Model
    , page : Page
    , mobileNavOpen : Bool
    }


init : List String -> ( Model, Cmd Msg )
init savedFavourites =
    ( Model WaitingForData savedFavourites Page.Schedule.init Schedule False, Data.getData DataLoaded )


navigation navOpen =
    nav [ class "navbar navbar-inverse navbar-fixed-top" ]
        [ div [ class "container-fluid" ]
            [ div [ class "navbar-header" ]
                [ button [ type_ "button", class "navbar-toggle collapsed", onClick ToggleMobileNav ]
                    [ span [ class "icon-bar" ] []
                    , span [ class "icon-bar" ] []
                    , span [ class "icon-bar" ] []
                    ]
                , div [ class "navbar-brand" ] [ text "Conf Tracker" ]
                ]
            , div [ classList [ ( "collapse navbar-collapse", True ), ( "in", navOpen ) ] ]
                [ ul [ class "nav navbar-nav" ]
                    [ li []
                        [ a [ href "#", onClick (SwitchPage Schedule) ] [ text "Schedule" ]
                        ]
                    , li
                        []
                        [ a [ href "#", onClick (SwitchPage Settings) ] [ text "Settings" ]
                        ]
                    ]
                ]
            ]
        ]


view model =
    case model.data of
        NotRequested ->
            div [] []

        WaitingForData ->
            Page.Loading.view

        DataFetched data ->
            div []
                [ navigation model.mobileNavOpen
                , div [ class "container-fluid" ]
                    [ case model.page of
                        Settings ->
                            Page.Settings.view
                                |> Html.map SettingsPageMsg

                        _ ->
                            Page.Schedule.view data.events model.schedulePage
                                |> Html.map SchedulePageMsg
                    ]
                ]

        DataFetchError ->
            div [ class "page page--error" ]
                [ div [ class "container-fluid" ]
                    [ h1 [] [ text "There was a problem loading data!" ]
                    , p [] [ text "Looks like there was a problem loading the events data, might be worth refreshing the page and trying again" ]
                    ]
                ]


update message model =
    case message of
        SchedulePageMsg msg ->
            case msg of
                Page.Schedule.EventViewMsg msg ->
                    case msg of
                        Views.Event.ToggleFavouriteEvent id ->
                            update (ToggleFavourite id) model

                _ ->
                    ( { model | schedulePage = Page.Schedule.update msg model.schedulePage }, Cmd.none )

        SettingsPageMsg msg ->
            case msg of
                Page.Settings.ClearFavourites ->
                    let
                        ( m, c ) =
                            model |> update ClearFavourites
                    in
                        ( m, c )

        DataLoaded (Ok data) ->
            let
                newData =
                    { data | events = Data.Event.setFavourites model.savedFavouritesList data.events }
            in
                ( { model | data = DataFetched newData }, Cmd.none )

        DataLoaded (Err _) ->
            ( { model | data = DataFetchError }, Cmd.none )

        ToggleFavourite id ->
            case model.data of
                DataFetched data ->
                    let
                        newData =
                            { data | events = Data.Event.toggleFavourite id data.events }

                        newFavourites =
                            newData.events
                                |> List.filter (\event -> event.favourite)
                                |> List.map (\event -> event.id)
                    in
                        ( { model | data = DataFetched newData }, Ports.saveFavourites newFavourites )

                _ ->
                    ( model, Cmd.none )

        ClearFavourites ->
            case model.data of
                DataFetched data ->
                    let
                        newData =
                            { data | events = Data.Event.clearFavourites data.events }
                    in
                        ( { model | data = DataFetched newData }, Ports.clearFavourites "" )

                _ ->
                    ( model, Cmd.none )

        SwitchPage page ->
            ( { model | page = page }, Cmd.none )

        ToggleMobileNav ->
            ( { model | mobileNavOpen = model.mobileNavOpen == False }, Cmd.none )


main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions =
            \_ -> Sub.none
        }
