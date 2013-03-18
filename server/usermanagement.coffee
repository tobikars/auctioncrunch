
Meteor.startup ->
  Accounts.config({sendVerificationEmail: true, forbidClientAccountCreation : false})

  # Validate username, sending a specific error message on failure.
  Accounts.validateNewUser (user) ->
    deb "validating user " + user.emails[0].address
    return true

  Accounts.emailTemplates.siteName = "AuctionCrunch"
  Accounts.emailTemplates.from = "AuctionCrunch Admin <auctioncrunch@gmail.com>"
  Accounts.emailTemplates.verifyEmail.subject = (user) ->
    return "Welcome to AuctionCrunch, " + user.emails[0].address
  Accounts.emailTemplates.verifyEmail.text = (user, url) ->
    return "Congratulations!\n\nYou have been selected to participate in the beta-version of AuctionCrunch!.\n\n\nTo activate your account, simply click the link below:\n\n\n#{url}"
    
Meteor.methods
  createACuser: (options) ->
    deb "creating user (server)" + options.email + options.password1
    email = options.email
    password = options.password1
    throw new Meteor.Error(401, "Passwords don't match!") unless options.password2 is password
    throw new Meteor.Error(402, "Password must be longer than 6 characters!") unless password && password.length > 6
    throw new Meteor.Error(501, "Email-address is not valid!" + options.email) unless options.email && validateEmail options.email
    id = Accounts.createUser {email: email, password: password}
    deb "created user (#{id}): "  + email
    Accounts.sendVerificationEmail id
    return "Success! Please check your inbox for the confirmation-email to log in." 
  upgradeAccount: (userID, userName) ->
    deb "upgraded account for: "  + userID + ", name: " + userName 
