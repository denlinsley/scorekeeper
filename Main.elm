module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)


{-| MODEL
`playerName` holds the value of the input
`playerId` holds the id of the player to edit (absence of value mesans we are adding a player)
-}
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
    { players = []
    , playerName = ""
    , playerId = Nothing
    , plays = []
    }



-- UPDATE


type Msg
    = Edit Player
    | Score Player Int
    | Input String
    | Save
    | Cancel
    | DeletePlay Play


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input value ->
            { model | playerName = value }

        Cancel ->
            { model | playerName = "", playerId = Nothing }

        Save ->
            if (String.isEmpty model.playerName) then
                model
            else
                save model

        Edit player ->
            { model | playerName = player.name, playerId = Just player.id }

        Score player points ->
            addPlay model player points

        _ ->
            model


save : Model -> Model
save model =
    case model.playerId of
        Just id ->
            edit model id

        Nothing ->
            add model


edit : Model -> Int -> Model
edit model id =
    let
        newPlayers =
            List.map
                (\player ->
                    if player.id == id then
                        { player | name = model.playerName }
                    else
                        player
                )
                model.players
    in
        { model
            | players = newPlayers
            , playerName = ""
            , playerId = Nothing
        }


add : Model -> Model
add model =
    let
        player =
            Player (List.length model.players + 1) model.playerName 0

        newPlayers =
            player :: model.players
    in
        { model | players = newPlayers, playerName = "" }


addPlay : Model -> Player -> Int -> Model
addPlay model player points =
    let
        play =
            Play (List.length model.plays + 1) player.id player.name points

        newPlays =
            play :: model.plays
    in
        { model | plays = newPlays }



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "scoreboard" ]
        [ h1 [] [ text "Score Keeper" ]
        , playerSection model.players
        , playerForm model
        , playSection model.plays
        , p [] [ text (toString model) ]
        ]


playerSection : List Player -> Html Msg
playerSection players =
    div []
        [ playerListHeader
        , playerList players
        , pointTotal
        ]


playerListHeader : Html msg
playerListHeader =
    header []
        [ div [] [ text "Name" ]
        , div [] [ text "Points" ]
        ]


playerList : List Player -> Html Msg
playerList players =
    ul []
        (List.map player players)


player : Player -> Html Msg
player player =
    li []
        [ i
            [ class "edit"
            , onClick (Edit player)
            ]
            []
        , div []
            [ text player.name ]
        , button
            [ type_ "button"
            , onClick (Score player 2)
            ]
            [ text "2pt" ]
        , button
            [ type_ "button"
            , onClick (Score player 3)
            ]
            [ text "3pt" ]
        , div []
            [ text (toString player.points) ]
        ]


pointTotal : Html msg
pointTotal =
    footer []
        [ div [] [ text "Total:" ] ]


playerForm : Model -> Html Msg
playerForm model =
    Html.form [ onSubmit Save ]
        [ input
            [ type_ "text"
            , placeholder "Add/Edit Player..."
            , value model.playerName
            , onInput Input
            ]
            []
        , button [ type_ "submit" ]
            [ text "Save" ]
        , button
            [ type_ "button"
            , onClick Cancel
            ]
            [ text "Cancel" ]
        ]


playSection : List Play -> Html Msg
playSection plays =
    div []
        [ playerListHeader
        , playList plays
        ]


playList : List Play -> Html Msg
playList plays =
    ul []
        (List.map play plays)


play : Play -> Html Msg
play play =
    li []
        [ i
            [ class "remove"
            , onClick (DeletePlay play)
            ]
            []
        , div [] [ text play.name ]
        , div [] [ text (toString play.points) ]
        ]



-- MAIN


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }



-- MOCK DATA


mockPlayers : List Player
mockPlayers =
    [ Player 1 "Suzie Greenberg" 10
    , Player 2 "Pete Carini" 20
    , Player 3 " Harry Hood" 30
    ]


mockPlays : List Play
mockPlays =
    [ Play 1 1 "Suzie Greenberg" 2
    , Play 2 1 "Pete Carini" 3
    , Play 3 1 " Harry Hood" 2
    ]
