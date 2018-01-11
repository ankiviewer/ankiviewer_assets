module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)
import Home exposing (..)


suite : Test
suite =
    describe "first test"
        [ test "formatUpdatedAt" <|
            \_ ->
                let
                    actual = formatUpdatedAt 1515096140
                    expected = "Thu 4 Jan at 20:02"
                in
                    Expect.equal actual expected
        ]
