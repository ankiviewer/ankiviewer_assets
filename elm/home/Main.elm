port module Home exposing (..)

import Html exposing (Html, h3, h4, div, button, img, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id, class, src)
import Http
import Json.Decode as Decode
import Date exposing (..)
import Time exposing (Time)
import Spinner exposing (spinner)
import Model exposing (Model)
import Msg exposing (..)

main : Program Never Model Msg
main
  = Html.program
  { init = init
  , view = view
  , update = update
  , subscriptions = subscriptions
  }

init : ( Model, Cmd Msg )
init = ( Model "" False "" "", fetchDeck )

fetchDeck : Cmd Msg
fetchDeck =
  let
    request =
      Http.get "/api/deck" decodeData
  in
     Http.send Deck request

view : Model -> Html Msg
view model = div []
  [ h3 [] [ text "Last Updated:" ]
  , h3 [] [ text model.error ]
  , h4 [] [ text model.updatedAt ]
  , button [
      id "sync_button",
      class "dib pa2 bg-light-grey br3",
      (onClick Sync)
      ]
      [ img [ src "/images/reload.svg" ] [] ]
  , div [ class "mv3" ]
    [ spinner model.syncHappening
    , syncDiv model.syncHappening model.syncMessage
    ]
  ]

syncDiv : Bool -> String -> Html msg
syncDiv visible message =
  let
    display = if visible then "db" else "dn"
  in
    div [ class (display ++ " mv2") ] [ text message ]

decodeData : Decode.Decoder Int
decodeData =
  Decode.at ["mod"] Decode.int

formatUpdatedAt : Int -> String
formatUpdatedAt int =
  let
      date = (int * 1000) |> toFloat |> Date.fromTime
  in
     toString(dayOfWeek(date)) ++ " " ++
     toString(day(date)) ++ " " ++
     toString(month(date)) ++ " at " ++
     doubleDigit(hour(date)) ++ ":" ++
     doubleDigit(minute(date))

doubleDigit : Int -> String
doubleDigit int =
    if int < 10 then "0" ++ (toString int) else  toString int

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    FetchDeck ->
      ( model, fetchDeck )
    Deck (Ok updatedAt) ->
      ({ model | updatedAt = (formatUpdatedAt updatedAt) }, Cmd.none)
    Deck (Err (Http.BadPayload error _)) ->
      ({model | error = error }, Cmd.none)
    Deck (Err unknownErr) ->
      ({model | error = "Unknown Error: " ++ (toString unknownErr)}, Cmd.none)
    Sync ->
      ({ model | syncHappening = True }, sync "deck" )
    SyncMessage syncMessage ->
      let
        syncHappening = syncMessage /= "Synced!"
      in
        ({ model | syncMessage = syncMessage, syncHappening = syncHappening }, Cmd.none )

port sync : String -> Cmd msg

port syncMessage : (String -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model
  = syncMessage SyncMessage
