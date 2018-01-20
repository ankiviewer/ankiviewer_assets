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
        , (filters model)
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


filters : SearchModel -> Html Msg
filters { filters } =
    let
        { tags, models, decks } =
            filters
    in
        div []
            [ div
                [ class
                    (if tags then
                        c
                     else
                        cdim
                    )
                , (onClick (ToggleFilter "tags"))
                ]
                [ text "tags" ]
            , div
                [ class
                    (if decks then
                        c
                     else
                        cdim
                    )
                , (onClick (ToggleFilter "decks"))
                ]
                [ text "decks" ]
            , div
                [ class
                    (if models then
                        c
                     else
                        cdim
                    )
                , (onClick (ToggleFilter "models"))
                ]
                [ text "models" ]
            ]


tags : SearchModel -> Html Msg
tags { tags, filters } =
    div
        [ class
            (if filters.tags then
                ""
             else
                "dn"
            )
        ]
        [ div [] [ text "tags:" ]
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
                        , (onClick (ToggleTag t.name))
                        ]
                        [ text t.name ]
                )
                tags
            )
        ]


decks : SearchModel -> Html Msg
decks { decks, filters } =
    div
        [ class
            (if filters.decks then
                ""
             else
                "dn"
            )
        ]
        [ div [] [ text "decks:" ]
        , div []
            (List.map
                (\d ->
                    div
                        [ class
                            (if d.showing then
                                c
                             else
                                cdim
                            )
                        , (onClick (ToggleDeck d.name))
                        ]
                        [ text d.name ]
                )
                decks
            )
        ]


models : SearchModel -> Html Msg
models { models, filters } =
    div
        [ class
            (if filters.models then
                ""
             else
                "dn"
            )
        ]
        [ div [] [ text "models:" ]
        , div []
            (List.map
                (\m ->
                    div
                        [ class
                            (if m.showing then
                                c
                             else
                                cdim
                            )
                        , (onClick (ToggleModel m.name))
                        ]
                        [ text m.name ]
                )
                models
            )
        ]


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
