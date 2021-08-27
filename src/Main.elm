module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, string)


-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL


type Model
  = Failure
  | Loading
  | Success String


init : () -> (Model, Cmd Msg)
init _ =
  ( Loading
  , getRandomJokes
  )



-- UPDATE


type Msg
  = MorePlease
  | GotJson (Result Http.Error String)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
        (Loading, getRandomJokes)

    GotJson result ->
      case result of
        Ok fullText ->
          (Success fullText, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  case model of
    Failure ->
        div []
        [ text "I was unable to load your Chuck Norris Joke."
        , button [ onClick MorePlease ] [ text "Try Again!"]
        ]


    Loading ->
      text "Loading..."

    Success joke ->
        div []
        [ button [ onClick MorePlease, style "display" "block"] [text "Hahaha, Give me another one!"]
        ,text joke ]

getRandomJokes : Cmd Msg
getRandomJokes =
  Http.get
    { url = "http://api.icndb.com/jokes/random"
    , expect = Http.expectJson GotJson jokeDecoder
    }

-- Decoder
jokeDecoder: Decoder String
jokeDecoder =
    field "value" (field "joke" string)
