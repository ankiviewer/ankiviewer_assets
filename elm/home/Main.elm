module Home exposing (..)

import Html
import Model exposing (Model, initialModel)
import Msg exposing (..)
import Update exposing (update)
import Api exposing (fetchDeck)
import View exposing (view)
import Subscriptions exposing (subscriptions)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( initialModel, fetchDeck )
