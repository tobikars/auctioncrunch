root = global ? window

root.Template.auctions.auctionList = ->
	u = Session.get "activeUser"
	return Auctions.find {user: u}

root.Template.auction.priceInfo = ->
  return "<strong>#{currency this.estimateCurrency} #{this.estimateAmountLow}</strong>" if (this.estimateAmountLow)

root.Template.auction.makerInfo = ->
  return "(Made by #{this.maker} est. #{this.placeDate})" if this.maker isnt "UNKNOWN"

