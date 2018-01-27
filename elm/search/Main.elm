port module Search exposing (..)

import Html
import Model exposing (SearchModel, initialModel)
import Msg exposing (Msg)
import View exposing (view)
import Update exposing (update)
import Api exposing (fetchCollection)


main : Program (Maybe SearchModel) SearchModel Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = updateWithStorage
        , subscriptions = \_ -> Sub.none
        }


port setStorage : SearchModel -> Cmd msg


updateWithStorage : Msg -> SearchModel -> ( SearchModel, Cmd Msg )
updateWithStorage msg model =
    let
        ( newModel, cmds ) =
            update msg model
    in
        ( newModel
        , Cmd.batch [ setStorage { newModel | notes = [] }, cmds ]
        )


init : Maybe SearchModel -> ( SearchModel, Cmd Msg )
init savedModel =
    ( Maybe.withDefault initialModel savedModel, fetchCollection )
