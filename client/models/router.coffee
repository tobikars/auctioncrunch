AuctionCrunchRouter = Backbone.Router.extend
  routes: 
    "register/": "register",
    "/": "main"
  main: ->
    Session.set "email", "test" 
    Session.set "tag_filter", null
  register: (email) -> 
    this.navigate "register/"+email, true

#Router = new AuctionCrunchRouter

#Meteor.startup ->
#  Backbone.history.start {pushState: true}
