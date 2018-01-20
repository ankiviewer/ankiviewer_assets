module Model exposing (..)


type alias SearchModel =
    { crt : Int
    , tags : List Tag
    , search : String
    , filters : Filters
    , decks : List Deck
    , models : List Model
    , columns : List String
    , notes : List Note
    , error : String
    }


initialModel : SearchModel
initialModel =
    SearchModel
        0
        []
        ""
        (Filters True True True)
        []
        []
        [ "front", "back", "tags" ]
        []
        ""


type alias Filters =
    { tags : Bool
    , decks : Bool
    , models : Bool
    }


type alias Tag =
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
