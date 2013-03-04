root = global ? window

root.Template.makers.makersList = ->
  res = Makers.find()
  deb "counted #{res.count()} Makers"
  return res

root.Template.makers.makersCount = ->
  Makers.find().count()

root.Template.makers.events = "click span.showMakers": ->
  showHide $("span.showMakers"), $(".makers")
