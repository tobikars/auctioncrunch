root = global ? window

root.Template.auctions.auctionRows = ->
  list = Auctions.find {}
  ar = []
  row = []
  i = 1 
  list.forEach (r) ->
    row.push r
    if i++ % 5 is 0
      ar.push row 
      row = []  
  ar.push row if row.length 
  return ar

#<root.Template.auctions.auctionList = ->
#	u = Session.get "activeUser"
#	return Auctions.find {user: u}

root.Template.auction.priceInfo = ->
  return "#{currency this.estimateCurrency} #{this.estimateAmountLow}" if (this.estimateAmountLow)

root.Template.auction.makerInfo = ->
  return "(by #{this.maker} est. #{this.mapYear})" if this.maker isnt "UNKNOWN"

root.Template.auction.mapTitle = ->
  return limitwords(this.title,20)

root.Template.auction.mapDescription = ->
  res = this.description
  # only return the description if it's different from the title
  if this.description isnt this.title
    return limitwords(res,40)
