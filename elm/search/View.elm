module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder)
import Html.Events exposing (onClick, onInput)
import Msg exposing (..)
import Model exposing (..)


view : SearchModel -> Html Msg
view model =
    div []
        [ div [] [ text model.error ]
        , div [] [ text (toString model.models) ]
        , (search model.search)
        , (filters model.filters)
        , (tags model)
        , (decks model)
        , (models model)
        , (assignFrontBack model)
        , (columns model)
        , div [] [ text ((model |> noteMapper |> List.length |> toString) ++ " Notes") ]
        , (notes model)
        ]


c : String
c =
    "b--red ba br2 ph2 pv1 lh-tag dib mb1 pointer montserrat mr1 bg-light-red hover-red"


cdim : String
cdim =
    "ba br2 ph2 pv1 lh-tag dib mb1 pointer montserrat mr1 hover-red"


assignFrontBack : SearchModel -> Html Msg
assignFrontBack model =
    div []
        [ div [] [ text "front:" ]
        , div []
            (model.models
                |> assignFrontBackFilter
                |> List.map
                    (\{decks, frontBack, front} ->
                        div []
                            [ div [ class "dib" ]
                                (
                                    ( decks
                                    |> List.map (\d -> div [ class "dib" ] [ text d ])
                                    |> List.intersperse ( span [] [ text " and " ] )
                                    ) ++ ( [ span [] [ text ": " ] ] )
                                )
                            , div [ class "dib" ]
                                (
                                    frontBack
                                    |> List.indexedMap (\fi fb ->
                                        div [ class "dib"
                                            , onClick (ToggleFront frontBack (
                                                    if front == fi then
                                                       -1
                                                    else
                                                        fi
                                                   )
                                               )
                                            ] [
                                                text (
                                                    if front == -1 then
                                                       fb
                                                   else if front == fi then
                                                       "front=" ++ fb
                                                   else
                                                       "back=" ++ fb
                                                )
                                              ]
                                    )
                                    |> List.intersperse ( span [] [ text ", " ] )
                                )   
                            ]
                    )
            )
        ]

type alias AssignFrontBack =
    { decks : List String
    , frontBack : List String
    , front : Int
    }


assignFrontBackFilter : List Model -> List AssignFrontBack
assignFrontBackFilter models =
    assignFrontBackFilterRecursive models []

assignFrontBackFilterRecursive : List Model -> List AssignFrontBack -> List AssignFrontBack
assignFrontBackFilterRecursive models acc =
    case models of
        [] ->
            []
        [ head ] ->
            handleAssignFrontBackFilter head acc
        head :: tail ->
            acc
            |> handleAssignFrontBackFilter head
            |> assignFrontBackFilterRecursive tail

handleAssignFrontBackFilter : Model -> List AssignFrontBack -> List AssignFrontBack
handleAssignFrontBackFilter head acc =
    if head.showing then
        if List.any (\a -> a.frontBack == (List.sort head.flds)) acc then
           List.map (\a ->
               if a.frontBack == (List.sort head.flds) then
                  { a | decks = ( head.name :: a.decks )}
              else
                  a
           )
           acc
       else
           { decks = [ head.name ], frontBack = (List.sort head.flds), front = head.front } :: acc
   else
       acc


search : String -> Html Msg
search str =
    input [ placeholder "Search", onInput Search ] []


filters : Filters -> Html Msg
filters { tags, models, decks, columns } =
    div []
        (List.map
            (\( str, tdm ) ->
                div
                    [ class
                        (if tdm then
                            c
                         else
                            cdim
                        )
                    , (onClick (ToggleFilter str))
                    ]
                    [ text str ]
            )
            [ ( "tags", tags )
            , ( "decks", decks )
            , ( "models", models )
            , ( "columns", columns )
            ]
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
            ((List.map
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
                ++ [ div
                        [ class
                            (if List.all (\tdm -> tdm.showing) tdms then
                                c
                             else
                                cdim
                            )
                        , (onClick (msg "all"))
                        ]
                        [ text "all" ]
                   ]
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


columns : SearchModel -> Html Msg
columns { columns, filters } =
    tdm ToggleColumn "columns" columns filters.columns


noteMapper : SearchModel -> List (List String)
noteMapper model =
    List.filterMap
        (\n ->
            if filterNote n model then
                Just (noteHeadersMapper model.columns n [])
            else
                Nothing
        )
        model.notes


filterNote : Note -> SearchModel -> Bool
filterNote n { search, tags, models, decks } =
    ((String.contains search n.front) || (String.contains search n.back))
        && (tags |> List.filter (\t -> t.showing) |> List.all (\t -> String.contains t.name n.tags))
        && (decks |> List.filter (\d -> d.showing) |> List.any (\d -> n.did == d.did))
        && (models |> List.filter (\m -> m.showing) |> List.any (\m -> n.mid == m.mid))


noteHeadersMapper : List Column -> Note -> List String -> List String
noteHeadersMapper nheads n acc =
    case nheads of
        [] ->
            []

        [ head ] ->
            acc ++ (extractNoteField n head)

        head :: tail ->
            noteHeadersMapper tail n (acc ++ (extractNoteField n head))


extractNoteField : Note -> Column -> List String
extractNoteField n { name, showing } =
    if showing then
        case name of
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

            "ord" ->
                [ toString n.ord ]

            _ ->
                [ "error!!!" ]
    else
        []


notes : SearchModel -> Html Msg
notes model =
    table []
        [ thead []
            (List.filterMap
                (\{ name, showing } ->
                    if showing then
                        Just (th [] [ text name ])
                    else
                        Nothing
                )
                model.columns
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
                (noteMapper model)
            )
        ]
