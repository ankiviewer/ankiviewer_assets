module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder)
import Html.Events exposing (onClick, onInput)
import Msg exposing (..)
import Model exposing (..)


-- TODO: Add card, ord?


columns =
    [ "front", "back", "tags", "reps", "lapses", "type", "queue", "due" ]


view : SearchModel -> Html Msg
view model =
    div []
        [ div [] [ text model.error ]
        , div [] [ text model.search ]
        , (search model.search)
        , (filters model.filters)
        , (tags model)
        , (decks model)
        , (models model)
        , (notes model)
        ]


c : String
c =
    "b--red ba br2 ph2 pv1 lh-tag dib mb1 pointer montserrat mr1 bg-light-red hover-red"


cdim : String
cdim =
    "ba br2 ph2 pv1 lh-tag dib mb1 pointer montserrat mr1 hover-red"


search : String -> Html Msg
search str =
    input [ placeholder "Search", onInput Search ] []


filters : Filters -> Html Msg
filters { tags, models, decks } =
    div []
        (List.map(
            \(str, tdm) ->
                div [ class
                        (if tdm then
                            c
                         else
                            cdim
                        )
                    , (onClick (ToggleFilter str))
                    ]
                    [ text str ]
            )
            [("tags", tags), ("decks", decks), ("models", models)]
        )


tdm : (String -> Msg) -> String -> List (Tdm a) -> Bool -> Html Msg
tdm msg str tdms filter =
    div
        [ class
            (if filter then
                ""
             else
                "dn"
            )
        ]
        [ div [] [ text (str ++ ":") ]
        , div []
            (List.map
                (\t ->
                    div
                        [ class
                            (if t.showing then
                                c
                             else
                                cdim
                            )
                        , (onClick (msg t.name))
                        ]
                        [ text t.name ]
                )
                tdms
            )
        ]


tags : SearchModel -> Html Msg
tags { tags, filters } =
    tdm ToggleTag "tags" tags filters.tags


decks : SearchModel -> Html Msg
decks { decks, filters } =
    tdm ToggleDeck "decks" decks filters.decks


models : SearchModel -> Html Msg
models { models, filters } =
    tdm ToggleModel "models" models filters.models


noteMapper : List String -> List Note -> List (List String)
noteMapper nheads ns =
    List.map (\n -> noteHeadersMapper nheads n []) ns


noteHeadersMapper : List String -> Note -> List String -> List String
noteHeadersMapper nheads n acc =
    case nheads of
        [] ->
            []

        [ head ] ->
            acc ++ (extractNoteField n head)

        head :: tail ->
            noteHeadersMapper tail n (acc ++ (extractNoteField n head))


extractNoteField : Note -> String -> List String
extractNoteField n header =
    case header of
        "front" ->
            [ n.front ]

        "back" ->
            [ n.back ]

        "tags" ->
            [ n.tags ]

        "reps" ->
            [ toString n.reps ]

        "lapses" ->
            [ toString n.lapses ]

        "type" ->
            [ toString n.ttype ]

        "queue" ->
            [ toString n.queue ]

        "due" ->
            [ toString n.due ]

        _ ->
            [ "error!!!" ]


notes : SearchModel -> Html Msg
notes { columns, notes } =
    table []
        [ thead []
            (List.map
                (\h ->
                    th [] [ text h ]
                )
                columns
            )
        , tbody []
            (List.map
                (\nrow ->
                    tr []
                        (List.map
                            (\ncol ->
                                td [] [ text ncol ]
                            )
                            nrow
                        )
                )
                (noteMapper columns notes)
            )
        ]
