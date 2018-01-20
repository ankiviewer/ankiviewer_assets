module Search exposing (..)

import Html
import Model exposing (SearchModel, initialModel)
import Msg exposing (Msg)
import View exposing (view)
import Update exposing (update)
import Api exposing (fetchCollection)


main : Program Never SearchModel Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : ( SearchModel, Cmd Msg )
init =
    ( initialModel, fetchCollection )
