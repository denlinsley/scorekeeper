module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


-- MODEL


type alias Model =
    { players : List Player
    , playerName : String
    , playerId : Maybe Int
    , plays : List Play
    }


type alias Player =
    { id : Int
    , name : String
    , points : Int
    }


type alias Play =
    { id : Int
    , playerId : Int
    , name : String
    , points : Int
    }


initModel : Model
initModel =
    { players = players
    , playerName = ""
    , playerId = Nothing
    , plays = []
    }



-- UPDATE


type Msg
    = Edit
    | Score Int
    | Input
    | Save
    | Cancel
    | DeletePlay Int


update : Msg -> Model -> Model
update msg model =
    model



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1
            []
            [ text "Score Keeper" ]
        , playerSection model.players
        , playerForm model
        , playSection model.plays
        ]


playerSection : List Player -> Html Msg
playerSection players =
    div
        []
        [ playerListHeader
        , playerList players
        ]


playerListHeader : Html msg
playerListHeader =
    div
        []
        [ span
            []
            [ text "Name" ]
        , span
            [ style [ ( "float", "right" ) ] ]
            [ text "Score" ]
        ]


playerList : List Player -> Html Msg
playerList players =
    div
        []
        (List.map player players)


player : Player -> Html Msg
player player =
    div
        []
        [ button
            [ onClick Edit ]
            [ text "Edit" ]
        , span
            []
            [ text player.name ]
        , button
            [ onClick (Score 2) ]
            [ text "2pt" ]
        , button
            [ onClick (Score 3) ]
            [ text "3pt" ]
        , span
            []
            [ text (toString player.points) ]
        ]


playerForm : Model -> Html Msg
playerForm model =
    div
        []
        [ input
            [ placeholder "Add/Edit Player"
            , value model.playerName
            , onClick Input
            ]
            []
        , button
            [ class "pure-button pure-button-primary"
            , onClick Save
            ]
            [ text "Save" ]
        , button
            [ class "pure-button"
            , onClick Cancel
            ]
            [ text "Cancel" ]
        ]


playSection : List Play -> Html Msg
playSection plays =
    div
        []
        [ text "playSection" ]



-- MAIN


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }


players : List Player
players =
    [ Player 1 "Suzie Greenberg" 10
    , Player 2 "Pete Carini" 20
    , Player 3 " Harry Hood" 30
    ]
