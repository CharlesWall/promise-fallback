


tryNext = (attempts=[], index=0)->
  checkResult = (result)->
    if result is null or result is undefined
      tryNext attempts, index + 1
    else result


  if index < attempts.length
    attempt = attempts[index]
    Promise.resolve(
      if typeof attempt is 'function'
        attempt().then checkResult
      else if typeof attempt?.then is 'function'
        attempt.then checkResult
      else
        checkResult(attempt)
    )

@fallback = (attempts)-> Promise.resolve tryNext attempts
