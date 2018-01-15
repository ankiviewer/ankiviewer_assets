module Model exposing (Model, initialModel)

type alias Model =
  { updatedAt : String
  , syncHappening: Bool
  , syncMessage : String
  , error : String
  }

initialModel : Model
initialModel = Model "" False "" ""
