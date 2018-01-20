module Update exposing (update)

import Msg exposing (..)
import Model exposing (..)
import Api exposing (fetchNotes)


handleTags : List String -> List Tag
handleTags tags =
    List.map
        (\t ->
            Tag t True
        )
        tags


handleModels : List ModelRes -> List Model
handleModels models =
    List.map
        (\m ->
            let
                { did, flds, mid, mod, name } =
                    m
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
    List.map
        (\d ->
            let
                { did, mod, name } =
                    d
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
                { error, payload } =
                    collectionRes

                { tagsAndCrt, models, decks } =
                    payload

                { crt, tags } =
                    tagsAndCrt
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

        Search str ->
            ( { model | search = str }, Cmd.none )

        ToggleFilter name ->
            let
                { tags, decks, models } =
                    model.filters
            in
                case name of
                    "tags" ->
                        let
                            filters =
                                { tags = not tags
                                , decks = decks
                                , models = models
                                }
                        in
                            ( { model | filters = filters }, Cmd.none )

                    "decks" ->
                        let
                            filters =
                                { tags = tags
                                , decks = not decks
                                , models = models
                                }
                        in
                            ( { model | filters = filters }, Cmd.none )

                    "models" ->
                        let
                            filters =
                                { tags = tags
                                , decks = decks
                                , models = not models
                                }
                        in
                            ( { model | filters = filters }, Cmd.none )

                    _ ->
                        ( model, Cmd.none )

        ToggleTag name ->
            let
                tags =
                    (List.map
                        (\t ->
                            if t.name == name then
                                { t | showing = not t.showing }
                            else
                                t
                        )
                        model.tags
                    )
            in
                ( { model | tags = tags }, Cmd.none )

        ToggleDeck name ->
            let
                decks =
                    (List.map
                        (\d ->
                            if d.name == name then
                                { d | showing = not d.showing }
                            else
                                d
                        )
                        model.decks
                    )
            in
                ( { model | decks = decks }, Cmd.none )

        ToggleModel name ->
            let
                models =
                    (List.map
                        (\m ->
                            if m.name == name then
                                { m | showing = not m.showing }
                            else
                                m
                        )
                        model.models
                    )
            in
                ( { model | models = models }, Cmd.none )
