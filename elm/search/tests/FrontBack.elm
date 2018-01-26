module FrontBack exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Model exposing (..)
import View exposing (assignFrontBackFilter, handleFrontBack)


models : List Model
models =
    [ { did = 1503955755
      , flds = [ "Front", "Back" ]
      , mid = 1436153614
      , mod = 1507832118
      , name = "Basic-2e165"
      , showing = True
      , front = -1
      }
    , { did = 1482060876
      , flds = [ "German", "English" ]
      , mid = 1482842770
      , mod = 1515966977
      , name = "de_reverse"
      , showing = True
      , front = -1
      }
    , { did = 1482060876
      , flds = [ "German", "English" ]
      , mid = 1482844263
      , mod = 1515967706
      , name = "de_en"
      , showing = True
      , front = -1
      }
    , { did = 1482060876
      , flds = [ "English", "German" ]
      , mid = 1482844395
      , mod = 1515967624
      , name = "en_de"
      , showing = True
      , front = -1
      }
    , { did = 1482060876
      , flds = [ "Front", "Back" ]
      , mid = 1498897408
      , mod = 1507832118
      , name = "preposition_case"
      , showing = True
      , front = -1
      }
    , { did = 1
      , flds = [ "Text", "Extra" ]
      , mid = 1502629924
      , mod = 1502629944
      , name = "Cloze"
      , showing = True
      , front = -1
      }
    , { did = 1
      , flds = [ "Front", "Back" ]
      , mid = 1507832105
      , mod = 1507832120
      , name = "Basic (and reversed card)"
      , showing = True
      , front = -1
      }
    ]


modelsSomeNotShowing : List Model
modelsSomeNotShowing =
    List.map
        (\m ->
            let
                names =
                    [ "Basic-2e165"
                    , "de_reverse"
                    , "preposition_case"
                    , "Cloze"
                    , "Basic (and reversed card)"
                    ]
            in
                if List.member m.name names then
                    { m | showing = False }
                else
                    m
        )
        models


modelsSomeFrontsSelected : List Model
modelsSomeFrontsSelected =
    List.map
        (\m ->
            if m.name == "Cloze" then
                { m | front = -1 }
            else
                { m | front = 1 }
        )
        modelsSomeNotShowing


suite : Test
suite =
    describe "suite"
        [ describe "assignFrontBackFilter"
            [ test "first" <|
                \_ ->
                    let
                        expected =
                            [ { decks = [ "Cloze" ]
                              , frontBack = [ "Extra", "Text" ]
                              , front = -1
                              }
                            , { decks = [ "en_de", "de_en", "de_reverse" ]
                              , frontBack = [ "English", "German" ]
                              , front = -1
                              }
                            , { decks = [ "Basic (and reversed card)", "preposition_case", "Basic-2e165" ]
                              , frontBack = [ "Back", "Front" ]
                              , front = -1
                              }
                            ]

                        actual =
                            assignFrontBackFilter models
                    in
                        Expect.equal actual expected
            , test "with some not showing" <|
                \_ ->
                    let
                        expected =
                            [ { decks = [ "en_de", "de_en" ]
                              , frontBack = [ "English", "German" ]
                              , front = -1
                              }
                            ]

                        actual =
                            assignFrontBackFilter modelsSomeNotShowing
                    in
                        Expect.equal actual expected
            , test "with some fronts selected" <|
                \_ ->
                    let
                        expected =
                            [ { decks = [ "en_de", "de_en" ]
                              , frontBack = [ "English", "German" ]
                              , front = 1
                              }
                            ]

                        actual =
                            assignFrontBackFilter modelsSomeFrontsSelected
                    in
                        Expect.equal actual expected
            ]
        , describe "handleFrontBack"
            [ test "first" <|
                -- front="German", flds sorted has "German" at index 1 so front=1"
                -- note has ord=0 so using unsorted flds first is at index 0
                \_ ->
                    let
                        note =
                            { cid = 1445190978
                            , nid = 1445190958
                            , cmod = 1513424622
                            , nmod = 1515880418
                            , mid = 1482842770
                            , tags = " verified-by-vanessa "
                            , front = "die Sekunde"
                            , back = "the second"
                            , did = 1482060876
                            , ord = 0
                            , ttype = 2
                            , queue = 2
                            , due = 667
                            , reps = 6
                            , lapses = 0
                            }

                        models =
                            [ { did = 1482060876
                              , flds = [ "German", "English" ]
                              , mid = 1482842770
                              , mod = 1515966977
                              , name = "de_reverse"
                              , showing = True
                              , front = 1
                              }
                            ]

                        actual =
                            handleFrontBack "front" models note

                        expected =
                            "die Sekunde"
                    in
                        Expect.equal actual expected
            , test "second" <|
                -- front="German", flds sorted has "German" at index 1 so front=1"
                -- note has ord=0 so using unsorted flds first is at index 0
                \_ ->
                    let
                        note =
                            { cid = 1503554648
                            , nid = 1503554479
                            , cmod = 1510927376
                            , nmod = 1515967706
                            , mid = 1482844263
                            , tags = " verified-by-vanessa "
                            , front = "schlimm__schlecht"
                            , back = "threateningly, emotionally wrong with serious consequences - bad, not good, poor"
                            , did = 1482060876
                            , ord = 0
                            , ttype = 2
                            , queue = 2
                            , due = 448
                            , reps = 8
                            , lapses = 0
                            }

                        models =
                            [ { did = 1482060876
                              , flds = [ "German", "English" ]
                              , mid = 1482844263
                              , mod = 1515967706
                              , name = "de_en"
                              , showing = True
                              , front = 1
                              }
                            ]

                        actual =
                            handleFrontBack "front" models note

                        expected =
                            "schlimm__schlecht"
                    in
                        Expect.equal actual expected
            , test "third" <|
                -- front="German", flds sorted has "German" at index 1 so front=1"
                -- note has ord=0 so using unsorted flds first is at index 0
                \_ ->
                    let
                        note =
                            { cid = 1482845621
                            , nid = 1482845611
                            , cmod = 1512143743
                            , nmod = 1515967622
                            , mid = 1482844395
                            , tags = " verified-by-vanessa "
                            , front = "die Seite"
                            , back = "the page"
                            , did = 1482060876
                            , ord = 0
                            , ttype = 2
                            , queue = 2
                            , due = 653
                            , reps = 9
                            , lapses = 0
                            }

                        models =
                            [ { did = 1482060876
                              , flds = [ "English", "German" ]
                              , mid = 1482844395
                              , mod = 1515967624
                              , name = "en_de"
                              , showing = True
                              , front = 1
                              }
                            ]

                        actual =
                            handleFrontBack "front" models note

                        expected =
                            "die Seite"
                    in
                        Expect.equal actual expected
            ]
        ]
