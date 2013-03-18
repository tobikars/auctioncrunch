root.Template.loginview.events = "click .btn-login": (e)->
  btn = e
  btn.preventDefault()
  $(".login-msg").hide()
  $(".btn-login").hide()
  $(".loginForm").hide()
  $(".login-spinner").show()
  Meteor.loginWithPassword $(".loginForm #email").val(), $(".loginForm #password").val(), (err) ->
    if err 
      deb "Error: " + err.reason
      errorTag $(".login-msg"), err.reason
      $(".login-msg").show()
      $(".btn-login").show()
      $(".loginForm").show()
    else 
      deb "login success!"
      Session.set 'page_id', "search"
      navSet "search"
      Router.navigate "search", false
    $(".login-spinner").hide()
