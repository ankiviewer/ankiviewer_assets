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
        initialFilters
        []
        []
        [ "front", "back", "tags" ]
        []
        ""


initialFilters : Filters
initialFilters =
    { tags = True
    , decks = True
    , models = True
    }


type alias Filters =
    { tags : Bool
    , decks : Bool
    , models : Bool
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


type alias TagsAndCrt =
    { crt : Int
    , tags : List Tag
    }


type alias Tag =
    { name : String
    , showing : Bool
    }


type alias Collection =
    { tagsAndCrt : TagsAndCrt
    , decks : List Deck
    , models : List Model
    }


type alias NotesRes =
    { error : String
    , payload : List Note
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
