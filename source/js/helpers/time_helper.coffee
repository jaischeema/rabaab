window.formatTime = (s) ->
  return '' unless s?
  ms = s % 1000
  s = (s - ms) / 1000
  secs = s % 60
  s = (s - secs) / 60
  mins = s % 60
  secs_string = if secs < 10
    "0#{secs}"
  else
    "#{secs}"
  return "#{mins}:#{secs_string}"
