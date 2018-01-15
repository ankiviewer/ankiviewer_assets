module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class)
import Msg exposing (..)
import Model exposing (..)

view : Model -> Html Msg
view model = div []
    [ div [] [ text model.error ]
    , (tags model.collection.tags)
    , div [] (
        List.map (\deck ->
            div []
                [ div [] [ text (toString deck.did) ]
                , div [] [ text deck.name ]
                ]
        )
        model.decks
    )
    , div [] (
        List.map (\model ->
            div []
                [ div [] [ text (toString model.mid)]
                , div [] ( List.map (\fld -> div [] [ text fld ]) model.flds )
                ]
        )
        model.models
    )
    , div [] [ text (toString model.notes) ]
    ]

tags : List String -> Html Msg
tags ts = div []
    (
        List.map(\t ->
            div [ class "b--red ba br2 ph2 pv1 lh-tag dib mb1 pointer montserrat mr1 bg-light-red hover-red"] [ text t ]
        )
        ts
    )
