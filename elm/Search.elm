module Search exposing (..)

import Html exposing (Html, Attribute, div, input, text, h1)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Date exposing (..)
import Time exposing(Time)
import Spinner exposing (spinner)
import Json.Decode exposing (list, int, string, Decoder)
import Json.Decode.Pipeline exposing (decode, required)

main : Program Never Model Msg
main
    = Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Model =
    { collection : ACollection
    , decks : List ADeck
    , models : List AModel
    , error : String
    }

type alias CollectionRes =
    { error : String
    , payload : Payload
    }
type alias Payload =
    { collection : ACollection
    , decks : List ADeck
    , models : List AModel
    }

type alias ACollection =
    { crt : Int
    , mod : Int
    , tags : List String
    }

type alias ADeck =
    { did : Int
    , mod : Int
    , name : String
    }

type alias AModel =
    { did : Int
    , flds : List String
    , mid : Int
    , mod : Int
    }

init : ( Model, Cmd Msg )
init =
    let
        collection = { crt = 0, mod = 0, tags = []}
        model =
            { collection = collection
            , decks = []
            , models = []
            , error = ""
            }
    in
        ( model, fetchCollection )

fetchCollection : Cmd Msg
fetchCollection =
    let
        request =
            Http.get "/api/collection" decodeCollection
    in
       Http.send FetchedCollection request

decodeCollection : Decoder CollectionRes
decodeCollection =
    decode CollectionRes
    |> required "error" string
    |> required "payload" decodePayload

decodePayload : Decoder Payload
decodePayload =
    decode Payload
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
    Json.Decode.list (
        decode ADeck
            |> required "did" int
            |> required "mod" int
            |> required "name" string
    )

decodeAModels : Decoder (List AModel)
decodeAModels =
    Json.Decode.list (
        decode AModel
            |> required "did" int
            |> required "flds" (list string)
            |> required "mid" int
            |> required "mod" int
    )

type Msg
    = FetchCollection
    | FetchedCollection (Result Http.Error CollectionRes)

view : Model -> Html Msg
view model = div []
    [ h1 [] [ text "Hello World" ]
    , div [] [ text model.error ]
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
    ]

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
                , Cmd.none
            )
        FetchedCollection (Err unknownErr) ->
            ({ model | error = (toString unknownErr)}, Cmd.none )

subscriptions : Model -> Sub Msg
subscriptions model
    = Sub.none
