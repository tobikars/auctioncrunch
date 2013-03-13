root = global ? window

#sites
root.Template.sites.scrapedSites = ->
  res = AuctionHouses.find()
  deb "counted #{res.count()} AuctionHouses"
  return res

root.Template.sites.auctionHousesCount = ->
  AuctionHouses.find().count()

root.Template.sites.events = "click span.showAuctionhouses": ->
  showHide $("span.showAuctionhouses"), $(".scrapedSites")

# maker summary
root.Template.makers.makersList = ->
  res = Makers.find()
  deb "counted #{res.count()} Makers"
  return res

root.Template.makers.makersCount = ->
  Makers.find().count()

root.Template.makers.events = "click span.showMakers": ->
  showHide $("span.showMakers"), $(".makers")

#region summary
root.Template.regions.regionList = ->
  res = Regions.find()
  deb "counted #{res.count()} Regions"
  return res

root.Template.regions.regionCount = ->
  Regions.find().count()

root.Template.regions.events = "click span.hideRegions": ->
  showHide $("span.hideRegions"), $(".regionList")

root.Template.reloadbutton.events = "click .reloadbutton": ->
  Meteor.call 'reloadAuctions', true, (err, data) ->
    deb "reloaded auctions: " + data  