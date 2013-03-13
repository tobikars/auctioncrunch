root = global ? window

root.Template.auctions.auctionRows = ->
  u = Session.get "activeUser"
  list = Auctions.find {user: u}
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

root.Template.auctions.auctionList = ->
	u = Session.get "activeUser"
	return Auctions.find {user: u}

root.Template.auction.priceInfo = ->
  return "#{currency this.estimateCurrency} #{this.estimateAmountLow}" if (this.estimateAmountLow)

root.Template.auction.makerInfo = ->
  return "(Made by #{this.maker} est. #{this.placeDate})" if this.maker isnt "UNKNOWN"

root.Template.auction.mapDescription = ->
    return this.description if this.description isnt this.title
