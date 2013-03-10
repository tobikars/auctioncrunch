root.Template.reloadbutton.events = "click span.reloadbutton": ->
	Meteor.call 'reloadAuctions', true, (err, data) ->
		deb "reloaded auctions: " + data  