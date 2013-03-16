#
# contains all startup and init info for the app.
# by Tobi Kars
# tobikars@gmail.com
#

root = global ? window

loadauctionsFlag = false # set loadauctions to true if you want to urge DB data and load the auctions-files on startup.

# The collections we use. 
# Auctions is too big not to send over the line, so we use paging for that. 
Auctions = new Meteor.Collection "auctions" 
Regions =  new Meteor.Collection "regions"
AuctionHouses =  new Meteor.Collection "auctionhouses"
Makers = new Meteor.Collection "makers"
UserSearches =  new Meteor.Collection "usersearches"

Meteor.startup ->
  # Startup Server 
  if root.Meteor.is_server
    deb "loading startup items.."
    if loadauctionsFlag
      loadauctions(true)
    else
      deb "not loading new auction files." 

    Meteor.publish 'auctions-by-user', (opts) ->
      page = opts.page or 1
      pageSize = opts.pagesize or 10
      f = new Filter({ 
        user: opts.user
        search1: opts.search1
        op1: opts.op1
        search2: opts.search2
        op2: opts.op2 
        price: opts.price 
        year: opts.year 
      })
      res = Auctions.find f.buildFilter(),
        sort:
          dateTime: 0
        limit: pageSize
        skip: ( (page-1) * pageSize)
      deb "found: " + res.count() + " results."
      return res

    Meteor.publish 'makers', () ->
      Makers.find {},
        sort:
          name: 1 
        limit: 100   

    Meteor.publish 'auctionhouses', () ->
      AuctionHouses.find {},
        sort:
          name: 1

    Meteor.publish 'regions', () ->
      Regions.find {},
        sort:
          name: 1

  # Startup Client functions
  if root.Meteor.is_client
    Session.set "activeUser", "tobi"
    Session.set "auctionsCount", 0
    Session.set "page", 1   
    Session.set "pageSize", 10   
    Session.set "pages", 0
    Session.set "searchTextA", ""
    Session.set "searchTextB", ""
    Session.set "searchOpA", "or"
    Session.set "searchOpB", "or"
    Session.set "searchYear", 2100 
    Session.set "searchPrice", 99999999 
    deb "subscribing to collections....."
    Meteor.autosubscribe ->
      fj = getFilterJSON();
      Meteor.subscribe "auctions-by-user", fj, () -> 
        deb "auctions loaded."

    Meteor.autosubscribe ->
      Meteor.subscribe "auctionhouses", () ->
        deb "auctionhouses loaded." 

    Meteor.autosubscribe ->
      Meteor.subscribe "regions", () ->
        deb "regions loaded." 

    Meteor.autosubscribe ->
      Meteor.subscribe "makers", () ->
        deb "makers loaded." 

    Meteor.autosubscribe ->
      Meteor.call 'getAuctionCount', getFilter(), (err, count) ->
        Session.set 'auctionsCount', count
        Session.set 'pages', (Math.ceil count / Session.get "pageSize")
        
    # start the router
    Backbone.history.start {pushState: true}

if root.Meteor.is_client
  root.Template.masthead.events = "click li": (e)->
    #deb "clicked:" + event.currentTarget.html()
    e.preventDefault()
    target = $(e.currentTarget).find("a").attr("href")
    Router.navigate target,true

# server section    
if root.Meteor.is_server
  deb "Defining methods on the server."
  Meteor.methods
    getAuctionCount: (f) ->
      c = Auctions.find(f).count()
      deb "counting auctions, found: " + c 
      return c
    reloadAuctions: (clearFlag) ->
      loadauctions clearFlag
