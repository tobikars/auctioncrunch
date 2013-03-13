# clone an object and all its attributes
clone = (obj) ->
  if not obj? or typeof obj isnt 'object'
    return obj
  if obj instanceof Date
    return new Date(obj.getTime()) 
  if obj instanceof RegExp
    flags = ''
    flags += 'g' if obj.global?
    flags += 'i' if obj.ignoreCase?
    flags += 'm' if obj.multiline?
    flags += 'y' if obj.sticky?
    return new RegExp(obj.source, flags) 
  newInstance = new obj.constructor()
  for key of obj
    newInstance[key] = clone obj[key]
  return newInstance

#debug logger, adds a standard date. Later will log to a file.  
deb = (l) ->
  console.log new Date().format("mm/dd/yy h:MM:ss.l") + ": " + l
 
extractKeywords = (fields, auction, blacklist) ->
  text = (text or "") + auction[field] + " " for field in fields
  # TODO: include natural library for natural language processing 
  return [] if (not text)
  return text.
    toUpperCase().
    split(/\s+/).
    filter((v) -> v.length > 2).
    filter( (v) -> v not in blacklist).
    filter( (v, i, a) -> a.lastIndexOf(v) is i)


make_md5 = (md5fields, auction) ->
  text = (text or "") + auction[field] for field in md5fields
  hex_md5 text 

# work on parsing the amounts etc. correctly and detec the currency:
#€400 - 600   
#$475.00\n\t\t\t
#455,000.03
fixAmount = (text) ->
  #deb "fixing amount: " + text
  return "" if not text
  return parseInt(text.replace(/[,$£€\u00a3\u20ac]/g,''))

detectCurrency = (text) ->
  return "" if not text
  return "EURO" if 1+text.indexOf "€"
  return "EURO" if 1+text.indexOf "\u20ac"
  return "USD" if 1+text.indexOf "$"
  return "GBP" if 1+text.indexOf "£"
  return "GBP" if 1+text.indexOf "\u00a3"
  return "ZAR" if 1+text.indexOf "ZAR"
  return "MXN" if 1+text.indexOf "MXN"
  return "UNKNOWN"

currency = (text) ->
  return "" if not text
  return "\u20ac" if 1+text.indexOf "EURO"
  return "$" if 1+text.indexOf "USD"
  return "\u00a3" if 1+text.indexOf "GBP"
  return "ZAR" if 1+text.indexOf "ZAR"
  return "MXN" if 1+text.indexOf "MXN"
  return "UNKNOWN"  
  
detectYear = (text) ->
  return parseInt text.match(/[1-9][0-9]{2,3}/)

showHide = (el, target) ->
  #showHTML = '<i class="icon-circle-arrow-down"></i>'
  #hideHTML = '<i class="icon-circle-arrow-up"></i>'
  showHTML = "down"
  hideHTML = "up"
  res = el.html()
  if res.indexOf(showHTML) > -1
    deb "showing " + el.html()
    res = el.html().replace showHTML, hideHTML
    deb "showing " + el.html()
    target.show()
  else
    deb "hiding " + res
    target.hide()
    res = el.html().replace hideHTML, showHTML
  el.html(res)