module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class)
import Msg exposing (..)
import Model exposing (..)


view : SearchModel -> Html Msg
view model =
    div []
        [ div [] [ text model.error ]
        , (filters model.filters)
        , (tags model.tags)
        , (decks model.decks)
        , (models model.models)
        , (notes model.notes)
        ]


c : String
c =
    "b--red ba br2 ph2 pv1 lh-tag dib mb1 pointer montserrat mr1 bg-light-red hover-red"


filters : List Filter -> Html Msg
filters fs =
    div []
        (List.map
            (\f ->
                div [] [ text f.name ]
            )
            fs
        )


tags : List Tag -> Html Msg
tags ts =
    div []
        [ div [] [ text "tags:" ]
        , div []
            (List.map
                (\t ->
                    div [ class c ] [ text t.name ]
                )
                ts
            )
        ]


decks : List Deck -> Html Msg
decks ds =
    div []
        (List.map
            (\d ->
                div [ class c ] [ text d.name ]
            )
            ds
        )


models : List Model -> Html Msg
models ms =
    div []
        (List.map
            (\m ->
                div [ class c ] [ text m.name ]
            )
            ms
        )


myList : List String
myList =
    [ "front", "back", "tags" ]


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

        _ ->
            [ "error!!!" ]



-- TODO: find nicer way to handle this


notes : List Note -> Html Msg
notes ns =
    table []
        [ thead []
            (List.map
                (\h ->
                    th [] [ text h ]
                )
                myList
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
                (noteMapper myList ns)
            )
        ]
