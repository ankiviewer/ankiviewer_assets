module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, classList, placeholder)
import Html.Events exposing (onClick, onInput)
import Html.Keyed as Keyed
import Msg exposing (..)
import Model exposing (..)


view : SearchModel -> Html Msg
view model =
    div []
        [ div [] [ text model.error ]
        , (search model.search)
        , (filters model.filters)
        , (tags model)
        , (decks model)
        , (models model)
        , (assignFrontBack model)
        , (columns model)
        -- , div [] [ text ((model |> noteMapper |> List.length |> toString) ++ " Notes") ]
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
                    (\{ decks, frontBack, front } ->
                        div []
                            [ div [ class "dib" ]
                                ((decks
                                    |> List.map (\d -> div [ class "dib" ] [ text d ])
                                    |> List.intersperse (span [] [ text " and " ])
                                 )
                                    ++ ([ span [] [ text ": " ] ])
                                )
                            , div [ class "dib" ]
                                (frontBack
                                    |> List.indexedMap
                                        (\fi fb ->
                                            div
                                                [ class "dib"
                                                , onClick
                                                    (ToggleFront frontBack
                                                        (if front == fi then
                                                            -1
                                                         else
                                                            fi
                                                        )
                                                    )
                                                ]
                                                [ text
                                                    (if front == -1 then
                                                        fb
                                                     else if front == fi then
                                                        "front=" ++ fb
                                                     else
                                                        "back=" ++ fb
                                                    )
                                                ]
                                        )
                                    |> List.intersperse (span [] [ text ", " ])
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
            List.map
                (\a ->
                    if a.frontBack == (List.sort head.flds) then
                        { a | decks = (head.name :: a.decks) }
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
        [ classList
            [ ("dn", not filter) ]
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


noteMapper : SearchModel -> List ( String, (List String) )
noteMapper model =
    List.filterMap
        (\n ->
            if filterNote n model then
                Just ((toString n.nid), noteHeadersMapper model.models model.columns n [])
            else
                Nothing
        )
        model.notes

stringInFrontBack : String -> String -> Bool
stringInFrontBack search fb =
    (String.contains (simplifyString search) (simplifyString fb))

simplifyString : String -> String
simplifyString str =
    str
    |> String.toLower
    |> String.trim
    |> String.map mapChars
    |> String.filter filterChars

mapChars : Char -> Char
mapChars c =
    case c of
        'ß' -> 's'
        'ä' -> 'a'
        'ö' -> 'o'
        'ü' -> 'u'
        _ -> c

filterChars : Char -> Bool
filterChars c =
    not (List.member c ['.', '-', '?', ','])

filterNote : Note -> SearchModel -> Bool
filterNote n { search, tags, models, decks } =
    ((stringInFrontBack search n.front) || stringInFrontBack search n.back)
        && (tags |> List.filter (\t -> t.showing) |> List.all (\t -> String.contains t.name n.tags))
        && (decks |> List.filter (\d -> d.showing) |> List.any (\d -> n.did == d.did))
        && (models |> List.filter (\m -> m.showing) |> List.any (\m -> n.mid == m.mid))


noteHeadersMapper : List Model -> List Column -> Note -> List String -> List String
noteHeadersMapper models columns n acc =
    case columns of
        [] ->
            []

        [ head ] ->
            acc ++ (extractNoteField models n head)

        head :: tail ->
            noteHeadersMapper models tail n (acc ++ (extractNoteField models n head))


switchFb : String -> Bool -> Note -> String
switchFb fb switch note =
    case ( fb, switch ) of
        ( "front", True ) ->
            note.back

        ( "back", True ) ->
            note.front

        ( "front", False ) ->
            note.front

        _ ->
            note.back


handleFrontBack : String -> List Model -> Note -> String
handleFrontBack fb models note =
    case (getModel note.mid models) of
        Just m ->
            let
                switch = if m.flds == (List.sort m.flds) then 0 else 1
            in
                switchFb fb (((m.front + switch) % 2) == 1) note

        Nothing ->
            note.front


getModel : Int -> List Model -> Maybe Model
getModel mid models =
    case List.filter (\m -> m.mid == mid) models of
        [] ->
            Nothing

        head :: tail ->
            Just head


extractNoteField : List Model -> Note -> Column -> List String
extractNoteField models n { name, showing } =
    if showing then
        case name of
            "front" ->
                [ handleFrontBack "front" models n ]

            "back" ->
                [ handleFrontBack "back" models n ]

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

keyedTbody : List (Attribute msg) -> List ( String, Html msg ) -> Html msg
keyedTbody =
  Keyed.node "tbody"


notes : SearchModel -> Html Msg
notes model =
    table []
        [ thead []
             <| notesHeaders model.columns
        , keyedTbody []
            (List.map
                notesKeyedRow
                (noteMapper model)
            )
        ]

notesHeaders : List Column -> List (Html Msg)
notesHeaders columns =
    List.filterMap
        (\{ name, showing } -> 
            if showing then
               Just (th [] [ text name ])
           else
               Nothing
        )
        columns

notesRow : List String -> Html Msg
notesRow rows =
    tr []
        (List.map
            notesCell
            rows
        )

notesKeyedRow : ( String, List String ) -> ( String, Html Msg )
notesKeyedRow ( nid, rows ) =
    ( nid, notesRow rows )

notesCell : String -> Html Msg
notesCell cell = td [] [ text cell ]
