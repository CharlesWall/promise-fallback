(function() {
  var tryNext;

  tryNext = function(attempts, index) {
    var attempt, checkResult;
    if (attempts == null) {
      attempts = [];
    }
    if (index == null) {
      index = 0;
    }
    checkResult = function(result) {
      if (result === null || result === void 0) {
        return tryNext(attempts, index + 1);
      } else {
        return result;
      }
    };
    if (index < attempts.length) {
      attempt = attempts[index];
      return Promise.resolve(typeof attempt === 'function' ? attempt().then(checkResult) : typeof (attempt != null ? attempt.then : void 0) === 'function' ? attempt.then(checkResult) : checkResult(attempt));
    }
  };

  this.fallback = function(attempts) {
    return Promise.resolve(tryNext(attempts));
  };

}).call(this);
