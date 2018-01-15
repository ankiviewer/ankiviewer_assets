module Subscriptions exposing (subscriptions)

import Ports exposing (syncMessage)
import Model exposing (Model)
import Msg exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    syncMessage SyncMessage
