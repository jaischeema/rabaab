(function() {
  window.formatTime = function(s) {
    var mins, ms, secs, secs_string;
    if (s == null) {
      return '';
    }
    ms = s % 1000;
    s = (s - ms) / 1000;
    secs = s % 60;
    s = (s - secs) / 60;
    mins = s % 60;
    secs_string = secs < 10 ? "0" + secs : "" + secs;
    return "" + mins + ":" + secs_string;
  };

}).call(this);
