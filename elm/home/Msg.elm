module Msg exposing (..)

import Http


type Msg
    = FetchDeck
    | Deck (Result Http.Error Int)
    | Sync
    | SyncMessage String
