module Api exposing (fetchCollection, fetchNotes)

import Json.Decode as Decode
import Json.Decode exposing (list, int, string, bool, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Http
import Model exposing (..)
import Msg exposing (..)


fetchCollection : Cmd Msg
fetchCollection =
    let
        request =
            Http.get "/api/collection" decodeCollection
    in
        Http.send FetchedCollection request


type alias Showing a =
    { a | showing : Bool }


createQuery : List (Showing a) -> (Showing a -> String) -> String
createQuery listModel extractKey =
    listModel
        |> List.filterMap
            (\m ->
                if m.showing then
                    Just (extractKey m)
                else
                    Nothing
            )
        |> String.join ","


fetchNotes : SearchModel -> Cmd Msg
fetchNotes model =
    let
        search =
            "search=" ++ model.search

        tags =
            "tags=" ++ (createQuery model.tags .name)

        decks =
            "decks=" ++ (createQuery model.decks (\d -> (toString d.did)))

        models =
            "models=" ++ (createQuery model.models (\m -> (toString m.mid)))

        params =
            String.join "&" [ search, tags, decks, models ]
    in
        Http.send FetchedNotes <|
            Http.get ("/api/notes?" ++ params) decodeNotes


decodeNotes : Decoder NotesRes
decodeNotes =
    decode NotesRes
        |> required "error" string
        |> required "payload" decodeNotesPayload


decodeNotesPayload : Decoder (List Note)
decodeNotesPayload =
    list
        (decode Note
            |> required "cid" (int)
            |> required "nid" (int)
            |> required "cmod" (int)
            |> required "nmod" (int)
            |> required "mid" (int)
            |> optional "tags" (string) ""
            |> required "front" (string)
            |> required "back" (string)
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
        |> required "payload" decodeCollectionPayloadRes


decodeCollectionPayloadRes : Decoder CollectionPayloadRes
decodeCollectionPayloadRes =
    decode CollectionPayloadRes
        |> required "collection" decodeTagsAndCrt
        |> required "decks" decodeDecks
        |> required "models" decodeModels


decodeTagsAndCrt : Json.Decode.Decoder TagsAndCrtRes
decodeTagsAndCrt =
    decode TagsAndCrtRes
        |> required "crt" int
        |> required "tags" (list string)


decodeDecks : Decoder (List DeckRes)
decodeDecks =
    list
        (decode DeckRes
            |> required "did" int
            |> required "mod" int
            |> required "name" string
        )


decodeModels : Decoder (List ModelRes)
decodeModels =
    list
        (decode ModelRes
            |> required "did" int
            |> required "flds" (list string)
            |> required "mid" int
            |> required "mod" int
            |> required "name" string
        )
