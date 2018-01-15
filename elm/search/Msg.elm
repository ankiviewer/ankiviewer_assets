module Msg exposing (..)

import Model exposing (..)
import Http


type Msg
    = FetchCollection
    | FetchedCollection (Result Http.Error CollectionRes)
    | FetchNotes
    | FetchedNotes (Result Http.Error NotesRes)
