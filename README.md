# promise-fallback
Function for promise fallback flow control
Returns the first resolution that is not null or undefined

Installation
```
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

example
``` javascript
function lookupDataByKey() {
  return fallback([
    localCache[key], //this could be a value like 2 or null

    cachedPromises[key], //this could be a promise that resolves to a value

    function() { //this could resolve to our data
      return getDataFromRedisAsync(key);
    },

    function() { //this could resolve to our data
      return getDataFromDatabaseAsync(key);
    },

    function() { //our data was not found throw an error
      throw new Error('Data not found with key: ' + key);
    }
  ]);  
}
```
