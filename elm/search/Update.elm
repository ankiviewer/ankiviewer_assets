module Update exposing (update)

import Msg exposing (..)
import Model exposing (..)
import Api exposing (fetchNotes)

handleTags : List String -> List Tag
handleTags tags =
    List.map(
        \t ->
            Tag t True
    )
    tags

handleModels : List ModelRes -> List Model
handleModels models =
    List.map(
        \m ->
            let
                {did, flds, mid, mod, name} = m
            in
                { did = did
                , flds = flds
                , mid = mid
                , mod = mod
                , name = name
                , showing = True
                }
    )
    models

handleDecks : List DeckRes -> List Deck
handleDecks decks =
    List.map(
        \d ->
            let
                {did, mod, name} = d
            in
               { did = did
               , mod = mod
               , name = name
               , showing = True
               }
    )
    decks


update : Msg -> SearchModel -> ( SearchModel, Cmd Msg )
update msg model =
    case msg of
        FetchCollection ->
            ( model, Cmd.none )

        FetchedCollection (Ok collectionRes) ->
            let
                { error, payload } = collectionRes
                { tagsAndCrt, models, decks } = payload
                { crt, tags } = tagsAndCrt
            in
              ( { model
                  | error = error
                  , crt = crt
                  , tags = (handleTags tags)
                  , models = (handleModels models)
                  , decks = (handleDecks decks)
                }
              , fetchNotes
              )

        FetchedCollection (Err unknownErr) ->
            ( { model | error = (toString unknownErr) }, Cmd.none )

        FetchNotes ->
            ( model, Cmd.none )

        FetchedNotes (Ok notesRes) ->
            ( { model | notes = notesRes.payload }, Cmd.none )

        FetchedNotes (Err unknownErr) ->
            ( { model | error = (toString unknownErr) }, Cmd.none )
