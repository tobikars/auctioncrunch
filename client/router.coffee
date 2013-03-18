AuctionCrunchRouter = Backbone.Router.extend
  routes: 
    "about/:user": "show_about"
    "search" : "show_search"
    "logout" : "show_logout"
    "*path" : "show_page"
  show_about : (u) ->
    navSet "about"
    Session.set 'page_id',"about"
    deb "user info:" + u
  show_search : () ->
    navSet "search"
    Session.set 'page_id','search'
  show_contact : () ->
    navSet "contact"
    Session.set 'page_id',"contact"
  show_logout : () ->
    Meteor.logout()
    navSet "home"
    Session.set 'page_id',"home"
  show_page : (path) ->
    path = "index" if path is "" 
    navSet path
    Session.set 'page_id', path

# the below function is used as the main controller
root.Template.main.renderPage = ->
  if not browserOK()
    return new Handlebars.SafeString(root.Template['sorryview']()) 

  name = "index"
  if (Session.get 'page_id')? 
    name = Session.get 'page_id'

  templateName = name + "view"
  deb "rendering: " + name
  if root.Template[templateName]
    return new Handlebars.SafeString(root.Template[templateName]())  
  else 
    deb "renderPage: template not found for: " + templateName
    #Default Landing/home page  
    return new Handlebars.SafeString(root.Template['indexview']()) 

Router = new AuctionCrunchRouter
deb "router loaded."
