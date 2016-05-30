# promise-fallback
Function for promise fallback flow control
Returns the first resolution that is not null or undefined

Installation
```bash
npm install promise-fallback
```

Require
``` javascript
var fallback = require('./fallback.js').fallback
```

#Usage
```javascript
fallback(array); //returns promise
```

#example
``` javascript
function lookupDataByKey() {
  return fallback([
    localCache[key], //this could be a value like 2 or null

    cachedPromises[key], //this could be a promise that resolves to a value

    function() { //this could resolve to our data
      //this only gets called if the previous attempts resolve to null/undefined
      return getDataFromRedisAsync(key);
    },

    function() { //this could resolve to our data
      //this only gets called if the previous attempts resolve to null/undefined
      return getDataFromDatabaseAsync(key);
    },

    function() { //our data was not found throw an error
      //this only gets called if the previous attempts resolve to null/undefined
      throw new Error('Data not found with key: ' + key);
    },

    function() { //this code will NEVER execute because the previous attempt rejected
      return 22;
    }
  ]);  
}
```

#Build
```bash
sh build.sh
```
or
```bash
coffee -p --no-header -c src/fallback.coffee > fallback.js
```

#Test

```bash
sh test.sh
```
or
```bash
mocha --compilers coffee:coffee-script/register -R spec --timeout 10000 $@
```
