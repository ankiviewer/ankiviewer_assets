module FrontBack exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Model exposing (..)
import View exposing (assignFrontBackFilter)


suite : Test
suite =
    describe "assignFrontBackFilter"
        [ test "first" <|
            \_ ->
                let
                    models : List Model
                    models =
                        [
                          { did = 1503955755
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
                    models : List Model
                    models =
                        [
                          { did = 1503955755
                          , flds = [ "Front", "Back" ]
                          , mid = 1436153614
                          , mod = 1507832118
                          , name = "Basic-2e165"
                          , showing = False
                          , front = -1
                          }
                        , { did = 1482060876
                          , flds = [ "German", "English" ]
                          , mid = 1482842770
                          , mod = 1515966977
                          , name = "de_reverse"
                          , showing = False
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
                          , showing = False
                          , front = -1
                          }
                        , { did = 1
                          , flds = [ "Text", "Extra" ]
                          , mid = 1502629924
                          , mod = 1502629944
                          , name = "Cloze"
                          , showing = False
                          , front = -1
                          }
                        , { did = 1
                          , flds = [ "Front", "Back" ]
                          , mid = 1507832105
                          , mod = 1507832120
                          , name = "Basic (and reversed card)"
                          , showing = False
                          , front = -1
                          }
                        ]
                    expected =
                        [ { decks = [ "en_de", "de_en" ]
                            , frontBack = [ "English", "German" ]
                            , front = -1
                            }
                        ]

                    actual =
                        assignFrontBackFilter models
                in
                    Expect.equal actual expected
        , test "with some fronts selected" <|
            \_ ->
                let
                    models : List Model
                    models =
                        [
                          { did = 1503955755
                          , flds = [ "Front", "Back" ]
                          , mid = 1436153614
                          , mod = 1507832118
                          , name = "Basic-2e165"
                          , showing = False
                          , front = 1
                          }
                        , { did = 1482060876
                          , flds = [ "German", "English" ]
                          , mid = 1482842770
                          , mod = 1515966977
                          , name = "de_reverse"
                          , showing = False
                          , front = 1
                          }
                        , { did = 1482060876
                          , flds = [ "German", "English" ]
                          , mid = 1482844263
                          , mod = 1515967706
                          , name = "de_en"
                          , showing = True
                          , front = 1
                          }
                        , { did = 1482060876
                          , flds = [ "English", "German" ]
                          , mid = 1482844395
                          , mod = 1515967624
                          , name = "en_de"
                          , showing = True
                          , front = 1
                          }
                        , { did = 1482060876
                          , flds = [ "Front", "Back" ]
                          , mid = 1498897408
                          , mod = 1507832118
                          , name = "preposition_case"
                          , showing = False
                          , front = 1
                          }
                        , { did = 1
                          , flds = [ "Text", "Extra" ]
                          , mid = 1502629924
                          , mod = 1502629944
                          , name = "Cloze"
                          , showing = False
                          , front = -1
                          }
                        , { did = 1
                          , flds = [ "Front", "Back" ]
                          , mid = 1507832105
                          , mod = 1507832120
                          , name = "Basic (and reversed card)"
                          , showing = False
                          , front = 1
                          }
                        ]
                    expected =
                        [ { decks = [ "en_de", "de_en" ]
                            , frontBack = [ "English", "German" ]
                            , front = 1
                            }
                        ]

                    actual =
                        assignFrontBackFilter models
                in
                    Expect.equal actual expected
        ]
