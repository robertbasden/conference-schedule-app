module Views.Presenter exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, src)
import Data.Presenter


view : Data.Presenter.Presenter -> Html msg
view presenter =
    let
        presenterDetails =
            [ div [] [ text presenter.name ]
            , case presenter.twitterHandle of
                Just handle ->
                    a [ href ("http://www.twitter.com/" ++ handle), class "small" ] [ text ("@" ++ handle) ]

                Nothing ->
                    div [] []
            ]
    in
        case presenter.thumbnail of
            Just thumbnail ->
                div [ class "media" ]
                    [ div [ class "media-left media-middle" ]
                        [ img [ src thumbnail, class "media-object presenter-thumbnail" ] [] ]
                    , div [ class "media-body" ]
                        presenterDetails
                    ]

            Nothing ->
                div [ class "media" ]
                    [ div [ class "media-body" ]
                        presenterDetails
                    ]
