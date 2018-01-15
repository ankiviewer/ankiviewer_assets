module Search exposing (..)

import Html exposing (Html, Attribute, div, input, text, h1)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Date exposing (..)
import Time exposing(Time)
import Spinner exposing (spinner)
import Json.Decode exposing (list, int, string, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Model exposing (..)

main : Program Never Model Msg
main
    = Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

init : ( Model, Cmd Msg )
init =
    ( Model (ACollection 0 0 []) [] [] [] "", fetchCollection )

fetchCollection : Cmd Msg
fetchCollection =
    let
        request =
            Http.get "/api/collection" decodeCollection
    in
        Http.send FetchedCollection request

fetchNotes : Cmd Msg
fetchNotes =
    let
        request =
            Http.get "/api/notes" decodeNotes
    in
       Http.send FetchedNotes request

decodeNotes : Decoder NotesRes
decodeNotes =
    decode NotesRes
    |> required "error" string
    |> required "payload" decodeNotesPayload

decodeNotesPayload : Decoder (List Note)
decodeNotesPayload =
    list (
        decode Note
            |> required "cid" (int)
            |> required "nid" (int)
            |> required "cmod" (int)
            |> required "nmod" (int)
            |> required "mid" (int)
            |> optional "tags" (string) ""
            |> required "one" (string)
            |> required "two" (string)
            |> required "did" (int)
            |> required "ord" (int)
            |> required "ttype" (int)
            |> required "queue" (int)
            |> required "due" (int)
            |> required "reps" (int)
            |> required "lapses" (int)
    )

decodeCollection : Decoder CollectionRes
decodeCollection =
    decode CollectionRes
    |> required "error" string
    |> required "payload" decodeCollectionPayload

decodeCollectionPayload : Decoder Collection
decodeCollectionPayload =
    decode Collection
    |> required "collection" decodeACollection
    |> required "decks" decodeADecks
    |> required "models" decodeAModels

decodeACollection : Json.Decode.Decoder ACollection
decodeACollection =
    decode ACollection
    |> required "crt" int
    |> required "mod" int
    |> required "tags" (list string)

decodeADecks : Decoder (List ADeck)
decodeADecks =
    list (
        decode ADeck
            |> required "did" int
            |> required "mod" int
            |> required "name" string
    )

decodeAModels : Decoder (List AModel)
decodeAModels =
    list (
        decode AModel
            |> required "did" int
            |> required "flds" (list string)
            |> required "mid" int
            |> required "mod" int
    )

type Msg
    = FetchCollection
    | FetchedCollection (Result Http.Error CollectionRes)
    | FetchNotes
    | FetchedNotes (Result Http.Error NotesRes)

view : Model -> Html Msg
view model = div []
    [ div [] [ text model.error ]
    , (tags model.collection.tags)
    , div [] (
        List.map (\deck ->
            div []
                [ div [] [ text (toString deck.did) ]
                , div [] [ text deck.name ]
                ]
        )
        model.decks
    )
    , div [] (
        List.map (\model ->
            div []
                [ div [] [ text (toString model.mid)]
                , div [] ( List.map (\fld -> div [] [ text fld ]) model.flds )
                ]
        )
        model.models
    )
    , div [] [ text (toString model.notes) ]
    ]

tags : List String -> Html Msg
tags ts = div []
    (
        List.map(\t ->
            div [ class "b--red ba br2 ph2 pv1 lh-tag dib mb1 pointer montserrat mr1 bg-light-red hover-red"] [ text t ]
        )
        ts
    )

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

subscriptions : Model -> Sub Msg
subscriptions model
    = Sub.none
