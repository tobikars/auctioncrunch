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
    Session.set "searchOpA", ""
    Session.set "searchOpB", ""
    Session.set "searchYear", 2100 
    Session.set "searchPrice", 99999999 
    deb "Subscribing to collections....."
    Meteor.autosubscribe ->
      fj = getFilterJSON();
      Meteor.subscribe "auctions-by-user", fj, () -> deb "auctions loaded." 

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


    deb "client startup done."

# startup done. Execute the below: 
    
# client section
if root.Meteor.is_client
     
  root.Template.toolbar.auctionsCount = ->
    Session.get "auctionsCount"

  root.Template.toolbar.activePage = ->
    Session.get "page" 

  root.Template.toolbar.query = ->
    res = "for query <strong>'#{Session.get "searchTextA"} / #{Session.get "searchTextB"}'</strong>"
  
  root.Template.toolbar.pageList = ->
    res = []   
    pcount = Session.get "pages"
    res.push i for i in [1..pcount] by 1
    deb "pages: " + res.length
    return res

  root.Template.toolbar.pageListStart = ->
    return ", pages: " if +(Session.get "pages") 

  root.Template.toolbar.morepages = ->
    return "....." if +(Session.get "page") < +(Session.get "pages") and +(Session.get "pages") > 20

  root.Template.pagelink.isActivePage = () ->
    return " active" if +(this) is Session.get "page"
    return ""

  root.Template.pagelink.isVisible = () ->
    vis = +(Session.get "page") + 20
    return " invisible" if +(this) >= vis          
    return ""

  root.Template.reloadbutton.events = "click span.reloadbutton": ->
    Meteor.call 'reloadAuctions', true, (err, data) ->
      deb "reloaded auctions: " + data  
  
  root.Template.toolbar.events = "click span.pagelink": (event) ->
    Session.set "page", +$(event.target).attr("id")
    #$.find(".pagelink .active").removeClass("active").$(event.target).addClass "active"
    deb "activepage: " + Session.get "page"
    
# server section    
if root.Meteor.is_server
  deb "Defining methods on the server."
  Meteor.methods
    getAuctionCount: (f) ->
      c = Auctions.find(f).count()
      deb "counting auctions, found: " + c 
      return c
    reloadAuctions: (clear) ->
      loadauctions clear



