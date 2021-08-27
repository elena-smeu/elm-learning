module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
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
        div [ style "background-color" "red"
        , style "top" "40%"
        , style "right" "30%"]
        [ text "I was unable to load your Chuck Norris Joke."
        , button [ onClick MorePlease ] [ text "Try Again!"]
        ]


    Loading ->
        div [
        style "background-color" "#2a9d8f", style "width" "100vw", style "height" "100vh"]
         [
          div[ style "position" "absolute", style "top" "30%", style "left" "5%"]
                 [button [ onClick MorePlease,
                  style "display" "block",
                   style "width" "600px",
                   style "height" "200px",
                    style "background-color" "#e9c46a"
                    , style "border" "none",
                    style "cursor" "pointer",
                     style "color" "#264653",
                      style "text-alight" "center",
                      style "border-radius" "12px",
                       style "font-size" "3rem" ] [text "Hahaha, Give me another one!"]
                 ],
         div [ style "position" "absolute", style "top" "30%", style "left" "40%", style "font-size" "5rem"]
                [ text "Loading..."]
                ]

    Success joke ->
        div [
        style "background-color" "#2a9d8f", style "width" "100vw", style "height" "100vh" ]
        [
        div[ style "position" "absolute", style "top" "30%", style "left" "5%"]
        [button [ onClick MorePlease,
         style "display" "block",
          style "width" "600px",
          style "height" "200px",
           style "background-color" "#e9c46a"
           , style "border" "none",
           style "cursor" "pointer",
            style "color" "#264653",
             style "text-alight" "center",
             style "border-radius" "12px",
              style "font-size" "3rem" ] [text "Hahaha, Give me another one!"]
        ],
        div [ style "position" "absolute", style "top" "30%", style "left" "40%", style "font-size" "5rem"]
        [ text joke]
        ]

getRandomJokes : Cmd Msg
getRandomJokes =
  Http.get
    { url = "https://api.icndb.com/jokes/random"
    , expect = Http.expectJson GotJson jokeDecoder
    }

-- Decoder
jokeDecoder: Decoder String
jokeDecoder =
    field "value" (field "joke" string)
