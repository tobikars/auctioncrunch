AuctionCrunchRouter = Backbone.Router.extend
  routes: 
    "about/:user": "show_about"
    "search" : "show_search"
    "*path" : "show_page"
  show_about : (u) ->
    navSet "about"
    Session.set 'page_id',"about"
  show_search : () ->
    navSet "search"
    Session.set 'page_id','search'
  show_contact : () ->
    navSet "contact"
    Session.set 'page_id',"contact"
  show_page : (path) ->
    path = "index" if path is "" 
    navSet path
    Session.set 'page_id', path

# the below function is used as the main controller
root.Template.main.renderPage = ->
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

navSet = (active) ->
  $(".masthead li.active").each () -> $(this).removeClass("active")
  $(".masthead li a[href=" + active + "]").parent().addClass("active")
