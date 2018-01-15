module Search exposing (..)

import Html
import Model exposing (Model, initialModel)
import Msg exposing (Msg)
import View exposing (view)
import Update exposing (update)
import Api exposing (fetchCollection)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchCollection )
