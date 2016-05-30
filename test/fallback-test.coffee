{fallback} = require '..'
assert = require 'assert'

assertBecomes = (promise, value, message)->
  promise.then (result)-> assert.equal result, value, message

assertIsRejected = (promise, message)->
  new Promise (resolve, reject)->
    promise
      .then -> reject new Error 'did not reject'
      .catch resolve

asyncOp = (val)-> new Promise (resolve)-> setImmediate -> resolve val

describe 'fallback', ->
  describe 'empty args', ->
    it 'should callback with undefined if no attempts are passed in', ->
      assertBecomes fallback(), undefined

  describe 'value attempts', ->
    it 'should resolve with a value if it is non null', ->
      Promise.all [
        assertBecomes fallback([undefined, null, 2]), 2
        assertBecomes fallback([2, null]), 2
        assertBecomes fallback([2, 3, null]), 2
        assertBecomes fallback([0, 2, null]), 0
      ]

  describe 'promise attempts', ->
    it 'should resolve to the first not null/undefined promise resolution', ->
      assertBecomes fallback([
        asyncOp null
        asyncOp undefined
        asyncOp 0
        -> throw new Error 'should not get here'
      ]), 0
    it 'should resolve to the last value if all resolutions are null/undefined', ->
      assertBecomes fallback([
        undefined
        asyncOp undefined
        asyncOp undefined
        asyncOp null
      ]), null

  describe 'promise functions', ->
    it 'should resolve with the first result of executing promise functions', ->
      assertBecomes fallback([
        null
        asyncOp null
        -> asyncOp undefined
        -> asyncOp 0
        -> asyncOp 2
        -> asyncOp 3
      ]), 0

  describe 'rejections', ->
    it 'should reject if it executes a function that rejects', ->
      Promise.all [
          assertIsRejected fallback([
              null,
              asyncOp null
              -> asyncOp null
              -> throw new Error 'FAIL'
              2
          ]),
          assertIsRejected fallback([
              null,
              asyncOp null
              -> asyncOp null
              -> Promise.reject new Error 'FAIL'
              2
          ])
      ]
