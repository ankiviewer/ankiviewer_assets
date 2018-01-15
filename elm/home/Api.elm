module Api exposing (..)

import Http
import Msg exposing (..)
import Json.Decode as Decode


fetchDeck : Cmd Msg
fetchDeck =
    let
        request =
            Http.get "/api/deck" decodeData
    in
        Http.send Deck request


decodeData : Decode.Decoder Int
decodeData =
    Decode.at [ "mod" ] Decode.int
