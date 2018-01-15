module Update exposing (..)

import Model exposing (Model)
import Http
import Msg exposing (..)
import Api exposing (fetchDeck)
import Ports exposing (sync)
import Date exposing (..)
import Time exposing (Time)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchDeck ->
            ( model, fetchDeck )

        Deck (Ok updatedAt) ->
            ( { model | updatedAt = (formatUpdatedAt updatedAt) }, Cmd.none )

        Deck (Err (Http.BadPayload error _)) ->
            ( { model | error = error }, Cmd.none )

        Deck (Err unknownErr) ->
            ( { model | error = "Unknown Error: " ++ (toString unknownErr) }, Cmd.none )

        Sync ->
            ( { model | syncHappening = True }, sync "deck" )

        SyncMessage syncMessage ->
            let
                syncHappening =
                    syncMessage /= "Synced!"
            in
                ( { model | syncMessage = syncMessage, syncHappening = syncHappening }, Cmd.none )


formatUpdatedAt : Int -> String
formatUpdatedAt int =
    let
        date =
            (int * 1000) |> toFloat |> Date.fromTime
    in
        toString (dayOfWeek (date))
            ++ " "
            ++ toString (day (date))
            ++ " "
            ++ toString (month (date))
            ++ " at "
            ++ doubleDigit (hour (date))
            ++ ":"
            ++ doubleDigit (minute (date))


doubleDigit : Int -> String
doubleDigit int =
    if int < 10 then
        "0" ++ (toString int)
    else
        toString int
