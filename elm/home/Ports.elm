port module Ports exposing (sync, syncMessage)

import Msg exposing (Msg)


port sync : String -> Cmd msg


port syncMessage : (String -> msg) -> Sub msg
