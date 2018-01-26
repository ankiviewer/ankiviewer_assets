module Model exposing (..)


type alias SearchModel =
    { crt : Int
    , tags : List Tag
    , search : String
    , filters : Filters
    , decks : List Deck
    , models : List Model
    , columns : List Column
    , notes : List Note
    , error : String
    }


initialModel : SearchModel
initialModel =
    SearchModel
        0
        []
        ""
        (Filters True False False False)
        []
        []
        initialColumns
        []
        ""


initialColumns : List Column
initialColumns =
    [ (Column "front" True)
    , (Column "back" True)
    , (Column "tags" True)
    , (Column "reps" False)
    , (Column "lapses" False)
    , (Column "type" False)
    , (Column "queue" False)
    , (Column "due" False)
    , (Column "ord" False)
    ]


type alias Filters =
    { tags : Bool
    , decks : Bool
    , models : Bool
    , columns : Bool
    }


type alias Tdm a =
    { a
        | name : String
        , showing : Bool
    }


type alias Tag =
    { name : String
    , showing : Bool
    }


type alias Column =
    { name : String
    , showing : Bool
    }


type alias Collection =
    { tagsAndCrt : { crt : Int, tags : List Tag }
    , decks : List Deck
    , models : List Model
    }


type alias Note =
    { cid : Int
    , nid : Int
    , cmod : Int
    , nmod : Int
    , mid : Int
    , tags : String
    , front : String
    , back : String
    , did : Int
    , ord : Int
    , ttype : Int
    , queue : Int
    , due : Int
    , reps : Int
    , lapses : Int
    }


type alias Deck =
    { did : Int
    , mod : Int
    , name : String
    , showing : Bool
    }


type alias Model =
    { did : Int
    , flds : List String
    , mid : Int
    , mod : Int
    , name : String
    , showing : Bool
    , front : Int -- -1: none selected. 0, 1: index of front
    }


type alias DeckRes =
    { did : Int
    , mod : Int
    , name : String
    }


type alias ModelRes =
    { did : Int
    , flds : List String
    , mid : Int
    , mod : Int
    , name : String
    }


type alias CollectionRes =
    { error : String
    , payload : CollectionPayloadRes
    }


type alias CollectionPayloadRes =
    { tagsAndCrt : TagsAndCrtRes
    , decks : List DeckRes
    , models : List ModelRes
    }


type alias TagsAndCrtRes =
    { crt : Int
    , tags : List String
    }


type alias NotesRes =
    { error : String
    , payload : List Note
    }
