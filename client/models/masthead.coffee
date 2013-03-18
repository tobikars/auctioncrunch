root = global ? window

root.Template.masthead.userWelcome = () ->
  u = Meteor.user()
  deb "User: " + u?
  deb "UserID: " + Meteor.userId()
  deb "UserEmails: " + u?.emails
  
  if Meteor.user()?.emails?[0]?.address
    u = Meteor.user()
    deb "user found: " + Meteor.userId()
    email = u.emails[0].address
    return "<a href='logout'>Logout</a>"
  else 
    return "Log in"

root.Template.masthead.logInOut = () ->
  if Meteor.user() 
    return "logout"
  return "login"

root.Template.masthead.logInOutDescription = () ->
  return "Log Out" if Meteor.user() 
  return "Log In" 

