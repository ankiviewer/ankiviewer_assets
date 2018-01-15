module Update exposing (update)

import Msg exposing (..)
import Model exposing (..)
import Api exposing (fetchNotes)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchCollection ->
            ( model, Cmd.none )
        FetchedCollection (Ok collectionRes) ->
            (
                { model
                | error = collectionRes.error
                , collection = collectionRes.payload.collection
                , models = collectionRes.payload.models
                , decks = collectionRes.payload.decks
                }
                , fetchNotes
            )
        FetchedCollection (Err unknownErr) ->
            ({ model | error = (toString unknownErr)}, Cmd.none )
        FetchNotes ->
            ( model, Cmd.none )
        FetchedNotes (Ok notesRes) ->
            ({ model | notes = notesRes.payload }, Cmd.none )
        FetchedNotes (Err unknownErr) ->
            ({ model | error = (toString unknownErr)}, Cmd.none )
