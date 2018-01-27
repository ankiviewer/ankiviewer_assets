module HandleTags exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Model exposing (..)
import Update exposing (handleTags)


suite : Test
suite =
    describe "suite"
        [ describe "handleTags"
            [ test "first" <|
                \_ ->
                    let
                        tags : List String
                        tags =
                            [ "one"
                            , "three"
                            ]

                        mtags : List Tag
                        mtags =
                            [ Tag "one" False
                            , Tag "two" True
                            ]

                        actual : List Tag
                        actual =
                            handleTags mtags tags

                        expected : List Tag
                        expected =
                            [ Tag "one" False
                            , Tag "three" True
                            ]
                    in
                        Expect.equal actual expected
            ]
        ]
