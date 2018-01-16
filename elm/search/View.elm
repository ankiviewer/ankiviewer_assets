module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class)
import Msg exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text model.error ]
        , (tags model.collection.tags)
        , (decks model.decks)
        , (models model.models)
        , (notes model.notes)

        -- , div [] [ text (toString model.notes) ]
        ]


c : String
c =
    "b--red ba br2 ph2 pv1 lh-tag dib mb1 pointer montserrat mr1 bg-light-red hover-red"


tags : List String -> Html Msg
tags ts =
    div []
        (List.map
            (\t ->
                div [ class c ] [ text t ]
            )
            ts
        )


decks : List ADeck -> Html Msg
decks ds =
    div []
        (List.map
            (\d ->
                div [ class c ] [ text d.name ]
            )
            ds
        )


models : List AModel -> Html Msg
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
    [ "one", "two", "tags" ]


noteMapper : List String -> List Note -> List (List String)
noteMapper nheads ns =
    List.map (\n -> noteHeadersMapper nheads n []) ns


noteHeadersMapper : List String -> Note -> List String -> List String
noteHeadersMapper nheads n acc =
    case nheads of
        [] ->
            []

        -- shouldn't reach here
        [ head ] ->
            acc ++ (extractNoteField n head)

        head :: tail ->
            noteHeadersMapper tail n (acc ++ (extractNoteField n head))


extractNoteField : Note -> String -> List String
extractNoteField n header =
    case header of
        "one" ->
            [ n.one ]

        "two" ->
            [ n.two ]

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
