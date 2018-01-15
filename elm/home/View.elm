module View exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id, class, src)
import Msg exposing (..)
import Model exposing (Model)
import Spinner exposing (spinner)


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Last Updated:" ]
        , h3 [] [ text model.error ]
        , h4 [] [ text model.updatedAt ]
        , button
            [ id "sync_button"
            , class "dib pa2 bg-light-grey br3"
            , (onClick Sync)
            ]
            [ img [ src "/images/reload.svg" ] [] ]
        , div [ class "mv3" ]
            [ spinner model.syncHappening
            , syncDiv model.syncHappening model.syncMessage
            ]
        ]


syncDiv : Bool -> String -> Html msg
syncDiv visible message =
    let
        display =
            if visible then
                "db"
            else
                "dn"
    in
        div [ class (display ++ " mv2") ] [ text message ]
