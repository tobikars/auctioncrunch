root = global ? window

root.Template.regions.regionList = ->
  res = Regions.find()
  deb "counted #{res.count()} Regions"
  return res

root.Template.regions.regionCount = ->
  Regions.find().count()

root.Template.regions.events = "click span.hideRegions": ->
  showHide $("span.hideRegions"), $(".regionList")
