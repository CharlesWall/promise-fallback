OUTPUT_FILE=index.js
INPUT_FILE=index.coffee
coffee -p --no-header -c src/$INPUT_FILE > $OUTPUT_FILE && echo 'success'
