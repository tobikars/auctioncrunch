#debug logger, adds a standard date. Later will log to a file.  
deb = (l) ->
  console.log new Date().format("mm/dd/yy h:MM:ss.l") + ": " + l
 