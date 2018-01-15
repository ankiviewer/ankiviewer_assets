module Model exposing (Model)

type alias Model =
  { updatedAt : String
  , syncHappening: Bool
  , syncMessage : String
  , error : String
  }

