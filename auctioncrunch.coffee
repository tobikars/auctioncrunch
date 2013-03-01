root = global ? window

loadauctionsFlag = false # set loadauctions to true if you want to urge DB data and load the auctions-files on startup.

# The collections we use. 
# Auctions is too big not to send over the line, so we use paging for that. 
Auctions = new Meteor.Collection "auctions" 
Regions =  new Meteor.Collection "regions"
AuctionHouses =  new Meteor.Collection "auctionhouses"
UserSearches =  new Meteor.Collection "usersearches"

Meteor.startup ->
  # Startup Server 
  if root.Meteor.is_server
    deb "loading startup items.."
    if loadauctionsFlag
      loadauctions(true)
    else
      deb "not loading new auction files." 

    Meteor.publish 'auctions-by-user', (userString, page, pageSize, searchText) ->
      searchText = searchText or ""
      f = new filter(userString, searchText)
      deb "reloading for: " + userString + " searchwords:" + searchText.split(" ")
      res = Auctions.find f.buildFilter(),
        sort:
          dateTime: 0
        limit: pageSize
        skip: ( (page-1) * pageSize)
      deb "filtering on user #{userString}, query #{searchText} on page #{page} for results #{pageSize}"
      return res

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
    Session.set "searchText", ""   
    deb "Subscribing to collections."
    Meteor.autosubscribe ->
      Meteor.subscribe "auctions-by-user", (Session.get "activeUser"), (Session.get "page"), (Session.get "pageSize"), (Session.get "searchText"), () ->
        deb "auctions loaded." 

    Meteor.autosubscribe ->
      Meteor.subscribe "auctionhouses", () ->
        deb "auctionhouses loaded." 

    Meteor.autosubscribe ->
      Meteor.subscribe "regions", () ->
        deb "regions loaded." 

    Meteor.autosubscribe ->
      Meteor.call 'getAuctionCount', (Session.get 'activeUser'), (Session.get 'searchText'), (err, count) ->
        Session.set 'auctionsCount', count
        Session.set 'pages', (Math.ceil count / Session.get "pageSize")


    deb "client startup done."

# startup done. Execute the below: 
    
# client section
if root.Meteor.is_client
  
  root.Template.usersearch.activeUser = ->
    Session.get "activeUser" 
    
  root.Template.titlesearch.titleSearch = ->
    Session.get "titleSearch"    
  
  root.Template.toolbar.auctionsCount = ->
    Session.get "auctionsCount"

  root.Template.toolbar.activeUser = ->
    Session.get "activeUser"
    
  root.Template.toolbar.activePage = ->
    Session.get "page" 

  root.Template.toolbar.query = ->
    if Session.get "searchText"
      return "for query <strong>'#{Session.get "searchText"}'</strong>"  
  
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

  root.Template.usersearch.events = "click input:button": ->
    u = $("#activeUser").val()
    Session.set "activeUser", u
    deb "activeUser: #{u}"

  root.Template.reloadbutton.events = "click span.reloadbutton": ->
    Meteor.call 'reloadAuctions', true, (err, data) ->
      deb "reloaded auctions: " + data  
  
  root.Template.titlesearch.events = "click input:button": ->
    s = $("#titleSearch").val()
    Session.set "searchText", s
    Session.set "page",1
    deb "searchText: #{s}"
  
  root.Template.toolbar.events = "click span.pagelink": (event) ->
    Session.set "page", +$(event.target).attr("id")
    #$.find(".pagelink .active").removeClass("active").$(event.target).addClass "active"
    deb "activepage: " + Session.get "page"
    
# server section    
if root.Meteor.is_server
  deb "Defining methods on the server."
  Meteor.methods
    getAuctionCount: (u, s) ->
      f = new filter(u,s)
      c = Auctions.find(f.buildFilter()).count()
      deb "counting for: " + u + " search: " + s + " found: " + c 
      return c
    reloadAuctions: (clear) ->
      loadauctions clear



