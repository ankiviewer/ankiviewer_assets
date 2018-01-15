module Model exposing (..)

type alias Model =
    { collection : ACollection
    , decks : List ADeck
    , models : List AModel
    , notes : List Note
    , error : String
    }

type alias CollectionRes =
    { error : String
    , payload : Collection
    }

type alias NotesRes =
    { error: String
    , payload : List Note
    }

type alias Note =
    { cid : Int
    , nid : Int
    , cmod : Int
    , nmod : Int
    , mid : Int
    , tags : String
    , one : String
    , two : String
    , did : Int
    , ord : Int
    , ttype : Int
    , queue : Int
    , due : Int
    , reps : Int
    , lapses : Int
    }

type alias Collection =
    { collection : ACollection
    , decks : List ADeck
    , models : List AModel
    }

type alias ACollection =
    { crt : Int
    , mod : Int
    , tags : List String
    }

type alias ADeck =
    { did : Int
    , mod : Int
    , name : String
    }

type alias AModel =
    { did : Int
    , flds : List String
    , mid : Int
    , mod : Int
    }

initialModel : Model
initialModel =
    Model (ACollection 0 0 []) [] [] [] ""
