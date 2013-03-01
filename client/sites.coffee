root = global ? window

root.Template.sites.scrapedSites = ->
  res = AuctionHouses.find()
  deb "counted #{res.count()} AuctionHouses"
  return res

root.Template.sites.auctionHousesCount = ->
  AuctionHouses.find().count()

root.Template.sites.events = "click span.showAuctionhouses": ->
  showHide $("span.showAuctionhouses"), $("#scrapedSites")
