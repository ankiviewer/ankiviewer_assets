module Update exposing (..)

import Msg exposing (..)
import Model exposing (..)
import Api exposing (fetchNotes)
import List.Extra exposing (..)


handleFilters : String -> Filters -> Filters
handleFilters name { tags, decks, models, columns } =
    case name of
        "tags" ->
            Filters (not tags) decks models columns

        "decks" ->
            Filters tags (not decks) models columns

        "models" ->
            Filters tags decks (not models) columns

        "columns" ->
            Filters tags decks models (not columns)

        _ ->
            Filters tags decks models columns


handleTdmToggle : String -> List (Tdm a) -> List (Tdm a)
handleTdmToggle name tdms =
    if name == "all" then
        List.map
            (\tdm ->
                { tdm | showing = not (List.all (\t -> t.showing) tdms) }
            )
            tdms
    else
        List.map
            (\tdm ->
                if tdm.name == name then
                    { tdm | showing = not tdm.showing }
                else
                    tdm
            )
            tdms


handleTags : List Tag -> List String -> List Tag
handleTags mtags tags =
    List.map
    (\t ->
        case find (\mt -> mt.name == t) mtags of
            Just mt ->
                mt
            Nothing ->
                Tag t True
    )
    tags


handleModels : List Model -> List ModelRes -> List Model
handleModels mmodels models =
    List.map
        (\{ did, flds, mid, mod, name } ->
            case find (\mm -> mm.mid == mid) mmodels of
                Just mm ->
                    mm
                Nothing ->
                    Model did flds mid mod name True -1
        )
        models


handleDecks : List Deck -> List DeckRes -> List Deck
handleDecks mdecks decks =
    List.map
        (\{ did, mod, name } ->
            case find (\md -> md.did == did) mdecks of
                Just dm ->
                    dm
                Nothing ->
                    Deck did mod name True
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
                    , tags = (handleTags model.tags tags)
                    , models = (handleModels model.models models)
                    , decks = (handleDecks model.decks decks)
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
                filters =
                    handleFilters name model.filters
            in
                ( { model | filters = filters }, Cmd.none )

        ToggleTag name ->
            let
                tags =
                    handleTdmToggle name model.tags
            in
                ( { model | tags = tags }, Cmd.none )

        ToggleDeck name ->
            let
                decks =
                    handleTdmToggle name model.decks
            in
                ( { model | decks = decks }, Cmd.none )

        ToggleModel name ->
            let
                models =
                    handleTdmToggle name model.models
            in
                ( { model | models = models }, Cmd.none )

        ToggleColumn name ->
            let
                columns =
                    handleTdmToggle name model.columns
            in
                ( { model | columns = columns }, Cmd.none )

        ToggleFront frontBack front ->
            let
                models =
                    List.map
                        (\m ->
                            if (List.sort m.flds) == frontBack then
                                { m | front = front }
                            else
                                m
                        )
                        model.models
            in
                ( { model | models = models }, Cmd.none )
