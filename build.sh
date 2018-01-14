#!/bin/bash

export AV_WEB_STATIC_DIR=../av_umbrella/apps/av_web/priv/static
export ELM_FILES="$(ls elm | awk '{print "elm/"$0}' | xargs)"
export ELM_COMMAND="node_modules/.bin/elm make $ELM_FILES --output $AV_WEB_STATIC_DIR/js/elm.js --yes"

function build() {
  if [[ $1 = "static" ]];then
    cp -R static/* $AV_WEB_STATIC_DIR
    cp ../av_umbrella/deps/phoenix/priv/static/phoenix.js $AV_WEB_STATIC_DIR/js
    cp ../av_umbrella/deps/phoenix_html/priv/static/phoenix_html.js $AV_WEB_STATIC_DIR/js
  elif [[ $1 = "css" ]];then
    sass css/main.scss:$AV_WEB_STATIC_DIR/css/app.css
  elif [[ $1 = "elm" ]];then
    if [[ $TRAVIS = true ]]; then
      bash -c "$TRAVIS_BUILD_DIR/sysocnfcpus/bin/sysocnfcpus -n 2 $ELM_COMMAND"
    else
      bash -c "$ELM_COMMAND"
    fi
  elif [[ $1 = "js" ]];then
    node_modules/.bin/rollup -c rollup.config.js
  else
    echo "build command: $1 not found"
  fi
}

function watch() {
  if [[ $1 = "static" ]];then
    nodemon -x './build.sh static' -w static -e png,svg,ico,txt
  elif [[ $1 = "css" ]];then
    sass --watch css/main.scss:$AV_WEB_STATIC_DIR/css/app.css
  elif [[ $1 = "elm" ]];then
    if [[ $FILE = "" ]];then
      echo "you need to run your elm watch command with exporting a \$FILE, e.g. FILE=\"elm/Search.elm\""
    else
      node_modules/.bin/elm-live "$FILE" --pushstate --output "$AV_WEB_STATIC_DIR/js/elm.js" --yes
    fi
  elif [[ $1 = "js" ]];then
    ./node_modules/.bin/rollup -c rollup.config.js -w
  else
    echo "watch command: $1 not found"
  fi
}

if [[ $1 = "static" ]] || [[ $1 = "css" ]] || [[ $1 = "elm" ]] || [[ $1 = "js" ]];then
  build $1
elif [[ $1 = "all" ]];then
  build static && build css && build elm && build js
elif [[ $1 = "watch" ]];then
  if [[ $2 = "static" ]] || [[ $2 = "css" ]] || [[ $2 = "elm" ]] || [[ $2 = "js" ]];then
    watch $2
  elif [[ $2 = "all" ]];then
    ./node_modules/.bin/nodemon -x './build.sh all' -e js,elm,css,png,svg,ico,txt
  else
    echo "watch command: $2 not found"
  fi
else
  echo "build command: $1 not found"
fi
