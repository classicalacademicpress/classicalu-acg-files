module Main exposing (main)

import Browser
import Browser.Events
import Html
import Html.Attributes
import Html.Events
import Json.Decode



-- MAIN


main : Program Json.Decode.Value Model Msg
main =
    Browser.element
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }



-- MODEL


type Model
    = Waiting Data
    | ZoomingIn Data
    | ZoomingOut Data
    | Error Json.Decode.Error


type alias Data =
    { height : Float
    , width : Float
    , scale : Float
    , src : String
    }


init : Json.Decode.Value -> ( Model, Cmd Msg )
init flags =
    let
        flagsDecoder =
            Json.Decode.map4 Data
                (Json.Decode.field "height" Json.Decode.float)
                (Json.Decode.field "width" Json.Decode.float)
                (Json.Decode.succeed 1.0)
                (Json.Decode.field "src" Json.Decode.string)
    in
    case Json.Decode.decodeValue flagsDecoder flags of
        Ok data ->
            ( Waiting data, Cmd.none )

        Err err ->
            ( Error err, Cmd.none )



-- UPDATE


type Msg
    = ClickZoomIn
    | ClickZoomOut
    | ZoomIn
    | ZoomOut
    | CancelZoom


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        Waiting data ->
            case msg of
                ClickZoomIn ->
                    ( ZoomingIn data, Cmd.none )

                ClickZoomOut ->
                    ( ZoomingOut data, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ZoomingIn data ->
            case msg of
                ZoomIn ->
                    if data.scale < 2 then
                        ( ZoomingIn { data | scale = data.scale + 0.01 }
                        , Cmd.none
                        )

                    else
                        ( model, Cmd.none )

                CancelZoom ->
                    ( Waiting data, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        ZoomingOut data ->
            case msg of
                ZoomOut ->
                    if data.scale > 0.2 then
                        ( ZoomingOut { data | scale = data.scale - 0.01 }
                        , Cmd.none
                        )

                    else
                        ( model, Cmd.none )

                CancelZoom ->
                    ( Waiting data, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        Error _ ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        ZoomingIn _ ->
            Sub.batch
                [ Browser.Events.onAnimationFrameDelta (\_ -> ZoomIn)
                , Browser.Events.onMouseUp <| Json.Decode.succeed CancelZoom
                ]

        ZoomingOut _ ->
            Sub.batch
                [ Browser.Events.onAnimationFrameDelta (\_ -> ZoomOut)
                , Browser.Events.onMouseUp <| Json.Decode.succeed CancelZoom
                ]

        _ ->
            Sub.none



-- VIEW


view : Model -> Html.Html Msg
view model =
    case model of
        Waiting data ->
            viewData data

        ZoomingIn data ->
            viewData data

        ZoomingOut data ->
            viewData data

        Error err ->
            Html.div []
                [ Html.strong [] [ Html.text "Shortcode error:" ]
                , Html.pre [] [ Html.text <| Json.Decode.errorToString err ]
                ]


viewData : Data -> Html.Html Msg
viewData data =
    Html.div
        [ Html.Attributes.class "acg-file-container"
        , Html.Attributes.style "height" <| String.fromFloat data.height ++ "px"
        , Html.Attributes.style "width" <| String.fromFloat data.width ++ "px"
        ]
        [ Html.div
            [ Html.Attributes.class "acg-file-frame-container"
            , Html.Attributes.style "height" <|
                String.fromFloat data.height
                    ++ "px"
            , Html.Attributes.style "width" <|
                String.fromFloat data.width
                    ++ "px"
            ]
            [ Html.iframe
                ([ Html.Attributes.attribute "frameBorder" "0"
                 , Html.Attributes.class "acg-file-frame"
                 , Html.Attributes.src data.src
                 ]
                    ++ transforms data
                )
                []
            , Html.div
                (Html.Attributes.class "acg-file-frame-overlay"
                    :: transforms data
                )
                []
            ]
        , Html.div [ Html.Attributes.class "acg-file-controls" ]
            [ Html.button
                [ Html.Attributes.class "acg-file-button"
                , Html.Events.onMouseDown ClickZoomOut
                ]
                [ Html.text "-" ]
            , Html.button
                [ Html.Attributes.class "acg-file-button"
                , Html.Events.onMouseDown ClickZoomIn
                ]
                [ Html.text "+" ]
            ]
        ]


transforms : Data -> List (Html.Attribute Msg)
transforms data =
    let
        height =
            String.fromFloat <| data.height / data.scale

        width =
            String.fromFloat <| data.width / data.scale

        scale =
            String.fromFloat data.scale

        transform =
            "scale(" ++ scale ++ "," ++ scale ++ ")"
    in
    [ Html.Attributes.style "-moz-transform" transform
    , Html.Attributes.style "-ms-transform" transform
    , Html.Attributes.style "-o-transform" transform
    , Html.Attributes.style "-webkit-transform" transform
    , Html.Attributes.style "height" <| height ++ "px"
    , Html.Attributes.style "transform" <| transform
    , Html.Attributes.style "width" <| width ++ "px"
    ]
